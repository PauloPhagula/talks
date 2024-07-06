int error;

// ...

error = step1();
if (error) {
 goto Error;
}

// ...

error = step2();
if (error) {
 goto Error;
}
