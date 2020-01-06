#!/usr/bin/env bash

state=$1
duration_in_sec=$2
elapsed_in_sec=$3
triggers=$4

complete_session() {
    event=$1
    duration=$2
    elapsed=$3
	
    pomodoro_directory="$HOME/PomodoroLogs"
    
    if [ ! -d "$pomodoro_directory" ]; then
        mkdir -p "$pomodoro_directory"
    fi
    
    output_file="${pomodoro_directory}/$(date +"%Y-%m-%d").txt"
    
    task_worked_on="$(zenity --entry --title="Pomodoro Timer" --text="What did you work on?" --width=450 --height=100)"
    
    worked_on_exit_code=$?
    
    zenity --question --text="Was this session productive?" --width=200 --height=100
    
    productive_exit_code=$?
    
    if [ "$productive_exit_code" -eq 0 ]; then
        session_was_productive=1
    else
        session_was_productive=0
    fi
    
    if [ "$productive_exit_code" -ne "0" ]; then
        not_productive="$(zenity --entry --title='Pomodoro Timer' --text='Why was your session not productive?' --width=450 --height=100)"
        not_productive_exit_code=$?
    
        improvement="$(zenity --entry --title='Pomodoro Timer' --text='What can you do to make your next session productive?' --width=500 --height=100)"
        improvement_exit_code=$?
    fi
    
    entry="$(date --iso-8601=minutes),${event},${duration},${elapsed},${task_worked_on},${session_was_productive},${not_productive},${improvement}"
    
    if [ ! -f "$output_file" ]; then
        echo "DateCompleted,Duration,Elapsed,TaskWorkedOn,WasProductive,NotProductiveReason,Improvement" >> $output_file
    fi
    
    echo $entry >> $output_file
}

if [ "$state" == "pomodoro" ]; then
    if [ "$triggers" == "complete" ]; then
        complete_session $triggers $duration_in_sec $elapsed_in_sec
    fi
    if [ "$triggers" == "skip" ]; then
        complete_session $triggers $duration_in_sec $elapsed_in_sec
    fi
fi

