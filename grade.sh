CPATH=".;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar"
rm -rf student-submission
rm -rf grading-area
rm -rf test-output.txt
mkdir grading-area

git clone $1 student-submission
files=`find student-submission`
count=0
for file in $files
do
    if [[ -f $file && $file == 'student-submission/ListExamples.java' ]]
    then
        echo 'Finished cloning'
        count=$(($count+1))
    fi
done
if [[ $count == 0 ]]
then
    echo 'Improper file submission'
    exit
fi

cp -r student-submission/*.java grading-area
rm -rf student-submission
cp -r TestListExamples.java grading-area
cp -r lib grading-area

#javac -cp $CPATH */*.java 
cd grading-area

javac -cp ".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar" *.java 
code=$?
if [[ $code != 0 ]]
then
    echo "error compiling: exit code $code"
    exit
fi

java -cp ".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar" org.junit.runner.JUnitCore TestListExamples > test-output.txt
# output=`find test-output.txt`
# cat $output
line=`grep 'Tests run:' test-output.txt`
echo $line
total=${line:11:1}
failures=${line:25:1}
# successes=$(($total-$failures))
# grade=$(($(($successes*100))/(($total))))
# echo "Your grade is $grade%"
