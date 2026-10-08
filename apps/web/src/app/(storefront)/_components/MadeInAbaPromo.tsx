import { Button } from '@/components/ui/button';

export function MadeInAbaPromo() {
  return (
    <section className="py-15 bg-[#1a1a1a] text-white relative overflow-hidden">
      <div className="max-w-7xl mx-auto px-8 relative z-10 flex flex-col md:flex-row items-center gap-12">
        
        {/* Left Side: Text and CTA */}
        <div className="flex-1 space-y-6 md:pr-12">
          <h2 className="text-4xl md:text-5xl font-extrabold tracking-tight text-white leading-tight">
            Made in Nigeria
          </h2>
          <p className="text-lg text-gray-300 max-w-lg font-medium">
            Discover authentic products crafted by the people and businesses that make Aba the manufacturing hub of West Africa. From premium leather shoes to expertly tailored garments.
          </p>
          <div className="pt-4">
            <Button size="lg" className="bg-white text-black hover:bg-gray-100 rounded-full font-bold px-8 h-12">
              Shop now
            </Button>
          </div>
        </div>
        
        {/* Right Side: Floating Slanted Cards */}
        <div className="flex-1 relative w-full h-[350px] md:h-[400px] flex items-center justify-center lg:justify-end pr-4">
          
          {/* Card 1 (Left, tilted left) */}
          <div className="absolute z-10 -rotate-12 translate-y-8 -translate-x-32 sm:-translate-x-48 bg-white rounded-2xl p-2 w-48 sm:w-56 shadow-2xl transition-transform hover:scale-105 hover:z-40 duration-300">
             <div className="aspect-[3/4] bg-gray-100 rounded-xl overflow-hidden flex items-center justify-center border border-gray-100">
               <div className="w-2/3 h-2/3 bg-gray-800 rounded-lg" style={{ maskImage: 'linear-gradient(to bottom, black 50%, transparent 100%)' }}></div>
             </div>
          </div>

          {/* Card 2 (Middle, tilted right) */}
          <div className="absolute z-20 rotate-6 -translate-y-4 -translate-x-8 sm:-translate-x-12 bg-white rounded-2xl p-2 w-48 sm:w-56 shadow-2xl transition-transform hover:scale-105 hover:z-40 duration-300">
             <div className="aspect-[3/4] bg-gray-100 rounded-xl overflow-hidden flex items-center justify-center border border-gray-100">
               <div className="w-full h-full bg-gray-800 opacity-90 rounded-lg flex flex-col justify-end p-4">
                  <div className="w-full h-2 bg-gray-600 rounded-full mb-2"></div>
                  <div className="w-2/3 h-2 bg-gray-600 rounded-full"></div>
               </div>
             </div>
          </div>

          {/* Card 3 (Right, tilted slightly left) */}
          <div className="absolute z-30 -rotate-3 translate-y-6 translate-x-32 sm:translate-x-40 bg-white rounded-2xl p-2 w-48 sm:w-56 shadow-2xl transition-transform hover:scale-105 hover:z-40 duration-300">
             <div className="aspect-[3/4] bg-gray-100 rounded-xl overflow-hidden flex items-center justify-center border border-gray-100 relative">
               <div className="absolute bottom-0 w-full h-1/2 bg-gray-800 rounded-t-3xl"></div>
               <div className="absolute top-1/4 w-3/4 h-8 bg-red-500 rounded flex items-center px-2">
                 <div className="w-4 h-4 bg-white rounded-full flex gap-1"></div>
               </div>
             </div>
          </div>
          
        </div>
      </div>
    </section>
  );
}
