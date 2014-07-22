# Message Roullete

Message Roullete is a simple application that lets anyone anonymously leave
a message for others to see. It is a work in progress. So far, it has the
functionality for a user to create messages and allows anyone to see the
messages that have been created.

Unfortunately, the developer that was building the site decided to move
to Tibet and take a vow of silence. Our client has contracted us to pick up
where she left off. Take a look at the stories in stories.csv to see what
is left...

## Setup

- `cp config/database.yml.example config/database.yml` X
- `rake db:create` X
- `rake db:migrate` X
- `RACK_ENV=test rake db:migrate`X
- `rspec`
- create a new Pivotal Tracker project and import stories.csv  X

## Putting the UD in CRUD

CRUD stands for:

- Create
- Read
- Update
- Delete

These represent the four most common operations that web application perform on data.
So far we have looked at the Create and Read part of CRUD. In this exercise we will be
exploring update and delete.
