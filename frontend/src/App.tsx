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
      <div className='text-4xl text-purple-400  px-20 bg-blue-100'>
      Quality Accelerators Test App
      </div>
      <p />
      <div className="card">
        <button className='text-4xl text-blue-400  px-20 bg-purple-100' onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
      </div>


      < nav className='bg-red-50 py-4' >
        <p className='font-light text-4xl text-red-400  px-20 '>The backend app: QA Jokes</p>
      </nav >
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