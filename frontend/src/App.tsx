import { useState, useEffect } from "react";
import './App.css'


function App() {
  const [error, setError] = useState(false)
  const [items, setItems] = useState([])
  const [count, setCount] = useState(0)

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch("http://localhost:8000")
        const result = await response.json()
        if (result) {
          setItems(result)
          setError(true)
        } else {
          console.error("Error fetching data:", response)
        }
      } catch (error) {
        console.error("Error fetching data:", error)
      }
    };
    fetchData()
  }, [])

  return (
    <>
      <header class="bg-white">
        <nav class="mx-auto flex max-w-5xl items-center justify-between p-6 lg:px-8" aria-label="Global">
          <div class="flex lg:flex-1">
              <button type="button" className="button flex items-center gap-x-1 text-sm font-semibold leading-6 text-gray-900" aria-expanded="false" onClick={() => setCount((count) => count + 1)}>
                Aantal kliks is {count}
              </button>
          </div>
          <div class="relative">
            <a href="#" class="-m-1.5 p-1.5">
              <span class="sr-only">Quality Accelerators</span>
              <img class="h-20 w-auto" src="src/assets/qa-logo.png" alt="Quality Accelerators Logo" />
            </a>
          </div>
        </nav>
      </header>

      <main className="px-10 py-20">
        {!error ? (
          
          <div
            className={`${error ? "flex" : "hidden"
              } h-full justify-center items-center text-center`}
          >
            <p className='text-xl font-medium'>
              So Sorry we could not find you items/jokes
              <span role='img' aria-label='dissapointed' className='text-4xl'>
                &#128542;
              </span>
            </p>
          </div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-x-6 gap-y-10">
            {items.map((item) => (
              <div
                key={item}
                className='flex flex-col bg-white drop-shadow hover:drop-shadow-lg hover:opacity-70 rounded-md'
              >
                <span className="h-12 object-cover rounded-tl-md rounded-tr-md font-semibold" role='img' aria-label='laugh'>
                  &#128514; id: {JSON.stringify(item.id)}
                </span>
                <p className='class="px-3 py-2 text-sm'>{JSON.stringify(item.item)}</p>
              </div>
            ))}
          </div>
        )}
      </main>
    </>
  )
}

export default App;