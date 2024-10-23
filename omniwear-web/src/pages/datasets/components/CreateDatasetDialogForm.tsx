import { Button } from 'primereact/button';
import { Dialog } from 'primereact/dialog';
import { InputText } from 'primereact/inputtext';
import { useState } from 'react';
import { useForm, SubmitHandler, SubmitErrorHandler } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { SelectButton } from 'primereact/selectbutton';
import { CreateDatasetDto, TDataset } from '@/api/dataset';
import { useToast } from '@/components/ToastContext';
import { InfoButton } from '@/components/InfoButton';
import StorageOptionEnum from '@/api/dataset/storage_option_enum';

// Define Zod schema based on the dataset DTO
const schema = z.object({
    inertial_collection_frequency: z.number().positive(),
    inertial_collection_duration_seconds: z.number().min(0),
    inertial_sleep_duration_seconds: z.number().min(0),
    inertial_features: z.string().min(1, 'Inertial features are required'),
    health_features: z.string().min(1, 'Health features are required'),
    health_reading_frequency: z.number().positive(),
    health_reading_interval: z.number().min(0),
    storage_option: z.enum([StorageOptionEnum.REMOTE, StorageOptionEnum.LOCAL], {
        required_error: 'Storage option is required',
    }),
});

type FormFields = z.infer<typeof schema>;

type CreateDatasetDialogProps = {
    onSubmit: (data: CreateDatasetDto) => Promise<TDataset>;
};

export default function CreateDatasetDialogForm({ onSubmit }: CreateDatasetDialogProps) {
    const [openFormDialog, setOpenFormDialog] = useState(false);
    const { showToast } = useToast();

    const defaultValues: FormFields = {
        inertial_collection_frequency: 10, // default from DTO
        inertial_collection_duration_seconds: 5, // default from DTO
        inertial_sleep_duration_seconds: 5, // default from DTO
        inertial_features: 'accelerometer,gyroscope', // default from DTO
        health_features: '*', // default from DTO
        health_reading_frequency: 4, // default from DTO
        health_reading_interval: 1800000, // default from DTO
        storage_option: StorageOptionEnum.REMOTE, // default from DTO
    };

    const {
        register,
        handleSubmit,
        reset,
        watch,
        formState: { errors, isSubmitting },
    } = useForm<FormFields>({
        resolver: zodResolver(schema),
        defaultValues,
    });

    const registerNumber = (name: keyof FormFields) => {
        return register(name, {
            setValueAs: (value) => Number(value),
        });
    };

    const storageOption = watch('storage_option');

    const handleFormSubmit: SubmitHandler<FormFields> = async (data) => {
        try {
            await onSubmit(data);
            showToast({
                severity: 'success',
                summary: 'Success',
                detail: 'Dataset created successfully',
            });
            reset(); // Resets the form fields to default values
        } catch (error) {
            showToast({ severity: 'error', summary: 'Error', detail: 'Failed to create dataset' });
        }
    };

    const handleFormError: SubmitErrorHandler<FormFields> = (errors) => {
        if (errors.inertial_features) {
            showToast({
                severity: 'error',
                summary: 'Form Error',
                detail: errors.inertial_features.message!,
            });
        }
        if (errors.health_features) {
            showToast({
                severity: 'error',
                summary: 'Form Error',
                detail: errors.health_features.message!,
            });
        }
    };

    const storageOptions = [
        { label: 'Remote', value: 'REMOTE' },
        { label: 'Local', value: 'LOCAL' },
    ];

    return (
        <>
            <Dialog
                header={<div className="text-center">Create Dataset</div>}
                visible={openFormDialog}
                style={{ width: '50vw' }}
                onHide={() => setOpenFormDialog(false)}
            >
                <form onSubmit={handleSubmit(handleFormSubmit, handleFormError)}>
                    {/* Inertial Features */}
                    <div className="flex flex-col gap-2">
                        <div>
                            <InfoButton content="The types of inertial features collected, such as accelerometer, gyroscope." />
                            <label className="ml-2" htmlFor="inertial_features">
                                Inertial Features:
                            </label>
                        </div>
                        <InputText
                            {...register('inertial_features')}
                            placeholder="e.g., accelerometer, gyroscope"
                            className={`max-h-10 flex justify-center items-center p-2 pl-4 grow shadow ${errors.inertial_features ? 'p-invalid' : ''}`}
                        />
                        {errors.inertial_features && (
                            <small className="p-error">{errors.inertial_features.message}</small>
                        )}
                    </div>
                    <div className="flex flex-col gap-4 mt-2">
                        {/* Inertial Collection Frequency */}
                        <div className="flex flex-col gap-2">
                            <div>
                                <InfoButton content="The frequency of inertial collection in Hz." />
                                <label className="ml-2" htmlFor="inertial_collection_frequency">
                                    Inertial Collection Frequency (Hz):
                                </label>
                            </div>
                            <InputText
                                type="number" 
                                {...registerNumber('inertial_collection_frequency')}
                                placeholder="e.g., 10"
                                className={`max-h-10 flex justify-center items-center p-2 pl-4 grow shadow ${errors.inertial_collection_frequency ? 'p-invalid' : ''}`}
                            />
                            {errors.inertial_collection_frequency && (
                                <small className="p-error">
                                    {errors.inertial_collection_frequency.message}
                                </small>
                            )}
                        </div>

                        {/* Inertial Collection Duration */}
                        <div className="flex flex-col gap-2">
                            <div>
                                <InfoButton content="The duration of inertial collection in seconds." />
                                <label
                                    className="ml-2"
                                    htmlFor="inertial_collection_duration_seconds"
                                >
                                    Inertial Collection Duration (seconds):
                                </label>
                            </div>
                            <InputText
                                type="number" 
                                {...registerNumber('inertial_collection_duration_seconds')}
                                placeholder="e.g., 5"
                                className={`max-h-10 flex justify-center items-center p-2 pl-4 grow shadow ${errors.inertial_collection_duration_seconds ? 'p-invalid' : ''}`}
                            />
                            {errors.inertial_collection_duration_seconds && (
                                <small className="p-error">
                                    {errors.inertial_collection_duration_seconds.message}
                                </small>
                            )}
                        </div>

                        {/* Inertial Sleep Duration */}
                        <div className="flex flex-col gap-2">
                            <div>
                                <InfoButton content="The sleep duration between inertial collections in seconds." />
                                <label className="ml-2" htmlFor="inertial_sleep_duration_seconds">
                                    Inertial Sleep Duration (seconds):
                                </label>
                            </div>
                            <InputText
                                type="number" 
                                {...registerNumber('inertial_sleep_duration_seconds')}
                                placeholder="e.g., 5"
                                className={`max-h-10 flex justify-center items-center p-2 pl-4 grow shadow ${errors.inertial_sleep_duration_seconds ? 'p-invalid' : ''}`}
                            />
                            {errors.inertial_sleep_duration_seconds && (
                                <small className="p-error">
                                    {errors.inertial_sleep_duration_seconds.message}
                                </small>
                            )}
                        </div>

                        {/* Health Features */}
                        <div className="flex flex-col gap-2">
                            <div>
                                <InfoButton content="The health features collected (e.g., heart rate, steps). Use '*' for all features." />
                                <label className="ml-2" htmlFor="health_features">
                                    Health Features:
                                </label>
                            </div>
                            <InputText
                                {...register('health_features')}
                                placeholder="e.g., *"
                                className={`max-h-10 flex justify-center items-center p-2 pl-4 grow shadow ${errors.health_features ? 'p-invalid' : ''}`}
                            />
                            {errors.health_features && (
                                <small className="p-error">{errors.health_features.message}</small>
                            )}
                        </div>

                        {/* Health Reading Frequency */}
                        <div className="flex flex-col gap-2">
                            <div>
                                <InfoButton content="The frequency of health readings in Hz." />
                                <label className="ml-2" htmlFor="health_reading_frequency">
                                    Health Reading Frequency (Hz):
                                </label>
                            </div>
                            <InputText
                                type="number" 
                                {...registerNumber('health_reading_frequency')}
                                placeholder="e.g., 4"
                                className={`max-h-10 flex justify-center items-center p-2 pl-4 grow shadow ${errors.health_reading_frequency ? 'p-invalid' : ''}`}
                            />
                            {errors.health_reading_frequency && (
                                <small className="p-error">
                                    {errors.health_reading_frequency.message}
                                </small>
                            )}
                        </div>

                        {/* Health Reading Interval */}
                        <div className="flex flex-col gap-2">
                            <div>
                                <InfoButton content="The interval between health readings in milliseconds." />
                                <label className="ml-2" htmlFor="health_reading_interval">
                                    Health Reading Interval (milliseconds):
                                </label>
                            </div>
                            <InputText
                                type="number"
                                {...registerNumber('health_reading_interval')}
                                placeholder="e.g., 1800000"
                                className={`max-h-10 flex justify-center items-center p-2 pl-4 grow shadow ${errors.health_reading_interval ? 'p-invalid' : ''}`}
                            />
                            {errors.health_reading_interval && (
                                <small className="p-error">
                                    {errors.health_reading_interval.message}
                                </small>
                            )}
                        </div>

                        {/* Storage Option */}
                        <div className="flex flex-col gap-2">
                            <div>
                                <InfoButton content="Where to save the data: LOCAL or REMOTE." />
                                <label className="ml-2" htmlFor="storage_option">
                                    Storage Option:
                                </label>
                            </div>
                            <SelectButton
                                value={storageOption}
                                {...register('storage_option')}
                                options={storageOptions}
                                className="w-full"
                            />
                            {errors.storage_option && (
                                <small className="p-error">{errors.storage_option.message}</small>
                            )}
                        </div>
                    </div>

                    <div className="flex justify-end mt-4">
                        <Button
                            label="Create Dataset"
                            type="submit"
                            className="p-2 bg-primary text-white"
                            loading={isSubmitting}
                        />
                    </div>
                </form>
            </Dialog>

            <Button
                icon="pi pi-plus"
                className="shadow bg-primary text-white"
                tooltip="Create a new dataset"
                tooltipOptions={{ position: 'left' }}
                onClick={() => setOpenFormDialog(true)}
            />
        </>
    );
}
