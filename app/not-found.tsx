'use client';

export default function NotFound() {
  return (
    <div className="min-h-screen bg-light-primary dark:bg-dark-primary flex items-center justify-center px-4">
      <div className="text-center max-w-md">
        <p className="text-6xl mb-4">🤔</p>
        <h1 className="text-3xl font-bold text-light-primary dark:text-dark-primary mb-2">Halaman Tidak Ditemukan</h1>
        <p className="text-light-secondary dark:text-dark-secondary mb-8">
          Maaf, halaman yang Anda cari tidak ada atau telah dihapus.
        </p>
        <a
          href="/"
          className="inline-block px-6 py-3 bg-emerald-500 text-white font-semibold rounded-lg hover:bg-emerald-600 transition-colors"
        >
          Kembali ke Beranda
        </a>
      </div>
    </div>
  );
}
