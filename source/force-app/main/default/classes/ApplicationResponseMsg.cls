global class ApplicationResponseMsg {
    global String ID {get; set;}
    global String Message {get; set;}
    global String Status {get; set;}

    public ApplicationResponseMsg()
    {
        this.ID = '';
        this.Message = '';
        this.Status = '';
    }
}