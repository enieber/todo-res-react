type inputHtml = {mutable value: string}

let setValue: (inputHtml, string) => unit = (ipt, str) => ipt.value = str

type todo = {id: int, name: string}
type action =
  | Add(string)
  | Remove(int)

type state = {list: array<todo>, loading: bool}

let reducer = (state, action) =>
  switch action {
  | Add(task_name) =>
    let list = Js.Array2.concat(
      state.list,
      [
        {
          id: Js.Math.random_int(0, 1000),
          name: task_name,
        },
      ],
    )
    {...state, list}
  | Remove(id) =>
    let list = Js.Array2.filter(state.list, item => item.id !== id)
    {...state, list}
  }

let initialTodos = []

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(
    reducer,
    {
      list: initialTodos,
      loading: false,
    },
  )
  let (taskName, setTaskName) = React.useState(_ => "")

  let items = state.list->Belt.Array.map(item => {
    <li key={Js.String2.make(item.id)}>
      {React.string(item.name)}
      <button onClick={_ => dispatch(Remove(item.id))}> {React.string("Remove")} </button>
    </li>
  })

  <div>
    <h1> {React.string("Todo List")} </h1>
    <input
      type_="text"
      onChange={event => {
        ReactEvent.Form.preventDefault(event)
        let value = ReactEvent.Form.target(event)["value"]
        setTaskName(_prev => value)
      }}
      value={taskName}
    />
    <button
      onClick={_ => {
        dispatch(Add(taskName))
        setTaskName(_prev => "")
      }}>
      {React.string("Add")}
    </button>
    <ul> {React.array(items)} </ul>
  </div>
}
