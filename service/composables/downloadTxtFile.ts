export const downloadTxtFile = (text: string) => {
    const element = document.createElement('a')
    const file = new Blob([text], { type: 'text/plain' })
    element.href = URL.createObjectURL(file)
    element.download = "extracted_text.txt"
    document.body.appendChild(element)
    element.click()
    document.body.removeChild(element)
}