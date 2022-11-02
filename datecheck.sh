#/bin/bash

check_date() {

    #Step-4: If entered month is not numerical if will convert it into numerical form. i.e Input $1=Jan, it will convert Jan into 1

    if (($month_number == 0)); then

        for i in {1..12}; do if [ $month_name == ${MONTHS[$i]} ]; then

            month_number=$i
        fi; done

    fi

    #Step-5: It will calculate the maximum days in a given month not considering it in a leap year. i.e Feb will have 28 maximum days

    max_days=$(date -d "$month_number/1 + 1 month - 1 day" "+%d")

    #Step-6: Now checking whether a year is leap or not

    a=$((year % 4))

    b=$((year % 100))

    c=$((year % 400))

    if (($a == 0 && $b != 0 || $c == 0)); then

        leap_year=1

    else

        leap_year=0

    fi

    #Step-7: If a year is leap and month is Feb, it will add one more day to it. i.e 29 maximum days for Feb

    if (($leap_year == 1 && $month_number == 2)); then

        max_days=29

    fi

    #Last-Step: Based on the Input condition it will give output.

    if [[ $days -gt $max_days || $days < 1 ]]; then

        echo "BAD INPUT: $month_name does not have $days days."

    elif [[ $leap_year -eq 0 && $2 -le $max_days ]]; then

        echo "EXISTS! $month_name $days $year is someone's birthday. not a leap year"

    elif [[ $leap_year -eq 1 && $2 -le $max_days ]]; then

        echo "EXISTS! $month_name $days $year is someone's birthday."

    elif [[ $leap_year -eq 0 && $month_number -eq 2 ]]; then

        echo "BAD INPUT: $month_name $year does not have $days days: not a leap year."

    else

        echo "BAD INPUT:"

    fi

}

#          ******Starting from here******

MONTHS=(Zero Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)

#Step-1: Checking Input Month is not empty i.e $1; then checking if input month exists in 'MONTHS' array or not.

if [[ $1 != "" ]]; then

    #Step-1.1: This command will find the given month in array whether input is in a lowercase. i.e if found inarray=1 else inarray=0

    inarray=$(echo ${MONTHS[@]} | grep -o ${1^} | wc -w)

fi

#Step-2: Checking number of Input Arguments if not valid? i.e should be equal to 3

if (($# != 3)); then

    echo "BAD INPUT:"

#Step-2.1: Checking inarray==1; if input month exists in 'MONTHS' array i.e $1=Jan

elif (($inarray == 1)); then

    days=$2

    year=$3

    month_name=${1^}

    month_number=0

    #Step-3: Calling function after validation of input arguments

    check_date

#Step-2.2: Checking entered month is in numerical value and is between 1-12; i.e $1=1

elif (($1 >= 1 && $1 <= 12)); then

    month_name=${MONTHS[$1]}

    month_number=$1

    days=$2

    year=$3

    #Step-3: Calling function after validation of input arguments

    check_date

else

    echo "BAD INPUT:"

fi
