import Link from "next/link";

export default function HomePage() {
  return (
    <main className="min-h-screen bg-gradient-to-br from-brand-950 via-brand-900 to-brand-800 flex flex-col items-center justify-center px-4">
      <div className="text-center space-y-6 animate-fade-in">
        {/* Logo */}
        <div className="flex items-center justify-center gap-3 mb-8">
          <div className="w-12 h-12 bg-brand-500 rounded-2xl flex items-center justify-center">
            <span className="text-2xl">✈</span>
          </div>
          <h1 className="text-4xl font-bold text-white tracking-tight">
            TravelMiles<span className="text-brand-400"> AI</span>
          </h1>
        </div>

        <p className="text-xl text-brand-200 max-w-xl mx-auto leading-relaxed">
          Pesquise passagens, compare preços em dinheiro e milhas, e planeje viagens
          com inteligência artificial.
        </p>

        <div className="flex flex-col sm:flex-row gap-4 justify-center mt-8">
          <Link
            href="/auth/register"
            className="px-8 py-3 bg-brand-500 hover:bg-brand-400 text-white font-semibold rounded-xl transition-colors duration-200"
          >
            Começar gratuitamente
          </Link>
          <Link
            href="/auth/login"
            className="px-8 py-3 border border-brand-400 hover:bg-brand-800 text-brand-200 font-semibold rounded-xl transition-colors duration-200"
          >
            Entrar
          </Link>
        </div>

        {/* Feature highlights */}
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-6 mt-16 max-w-3xl mx-auto">
          {[
            { icon: "🔍", title: "Busca inteligente", desc: "Encontre as melhores tarifas em segundos" },
            { icon: "💎", title: "Comparador de milhas", desc: "Veja o valor real das suas milhas" },
            { icon: "🤖", title: "IA integrada", desc: "Recomendações personalizadas de destinos" },
          ].map((f) => (
            <div key={f.title} className="bg-white/5 border border-white/10 rounded-2xl p-6 text-left">
              <span className="text-3xl">{f.icon}</span>
              <h3 className="text-white font-semibold mt-3">{f.title}</h3>
              <p className="text-brand-300 text-sm mt-1">{f.desc}</p>
            </div>
          ))}
        </div>
      </div>
    </main>
  );
}
