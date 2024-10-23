import { unparse } from 'papaparse';

export const downloadCSV = <T>(data: T[], fileName: string = 'data.csv') => {
    if (!data || !data.length) {
        console.warn('No data to download');
        return;
    }

    const csvContent = unparse(data);
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);

    link.href = url;
    link.setAttribute('download', fileName);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);
};
