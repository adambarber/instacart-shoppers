
var QuizWidgetGameScreen = React.createClass({
  getInitialState: function() {
    return {
      currentLevel: 0,
      answers: {}
    };
  },
  quizLevels: function() {
    return([
      {
        correctAnswer: 1,
        question: "Which one of these is the Red Fish?",
        items: [
          {name: 'Red Fish', img: '//placehold.it/200x200', id: 1},
          {name: 'Blue Fish', img: '//placehold.it/200x200', id: 2},
          {name: '1 Fish', img: '//placehold.it/200x200', id: 3},
          {name: '2 Fish', img: '//placehold.it/200x200', id: 4}
        ]
      },
      {
        correctAnswer: 2,
        question: "Which one of these is the Green Fish?",
        items: [
          {name: 'Orange Fish', img: '//placehold.it/200x200', id: 1},
          {name: 'Green Fish', img: '//placehold.it/200x200', id: 2},
          {name: 'Purple Fish', img: '//placehold.it/200x200', id: 3},
          {name: 'Yellow Fish', img: '//placehold.it/200x200', id: 4}
        ]
      }
    ])
  },
  onItemClick: function(itemId) {
    var currentLevel = this.quizLevels()[this.state.currentLevel]
    var answers = this.state.answers
    answers[this.state.currentLevel] = itemId
    this.setState({
      answers: answers
    })
  },
  submitAnswer: function() {
    var levelCount = this.quizLevels().length
    var nextLevel = this.state.currentLevel + 1
    if(nextLevel === levelCount) {
      this.props.onQuizComplete()
    } else {
      this.setState({ currentLevel: nextLevel })
    }
  },
  renderLevels: function() {
    var _self = this
    var currentLevel = this.quizLevels()[this.state.currentLevel]
    var selectedAnswer = this.state.answers[this.state.currentLevel]
    return(
      <div>
        <div className='level-question'>{currentLevel.question}</div>
        <ul className='level-items'>
          {currentLevel.items.map(function(item, idx) {
            var className = selectedAnswer === item.id ? 'level-item selected' : 'level-item';
            return(<li className={className} onClick={_self.onItemClick.bind(_self, item.id)}>
              <img src={item.img} />
              <span>{item.name}</span>
            </li>)
          })}
        </ul>
      </div>
    )
  },
  render: function() {
    return (
      <div className='content-panel game-screen'>
        { this.renderLevels() }
        <div className='button' onClick={this.submitAnswer}>Select Item</div>
      </div>
    );
  }
});

var QuizWidgetIntro = React.createClass({
  onClick: function(e) {
    this.props.onStartButtonClick()
  },
  render: function() {
    return (
      <div className='content-panel quiz-intro'>
        <h4>The Instacart Shoppers Quiz!</h4>
        <p>Do you have what it takes to be an Instacart Shopper?</p>

        <div className='button' onClick={this.onClick}>
          Start The Quiz
        </div>
      </div>
    );
  }
})

var QuizComplete = React.createClass({
  render: function() {
    return (
      <div className='content-panel quiz-complete'>
        <h4>Nice Job!</h4>
        <p>You did great. Click the button below to keep moving.</p>

        <a className='button continue-application-button' href={window.continueApplicationLink}>
          Continue Your Application
        </a>
      </div>
    );
  }
})

var QuizWidget = React.createClass({
  onStartButtonClick: function() {
    var _self = this
    window.$.ajax({
      url: window.updateApplicationStateUrl,
      method: 'POST',
      data: {
        id: window.currentApplicationID,
        workflow_state: 'quiz_started'
      }
    }).done(function(res) {
      _self.setState({
        currentState: 'gameStarted'
      })
    })
  },
  onQuizComplete: function() {
    var _self = this
    window.$.ajax({
      url: window.updateApplicationStateUrl,
      method: 'POST',
      data: {
        id: window.currentApplicationID,
        workflow_state: 'quiz_completed'
      },
      success: function(res) {
        _self.setState({
          currentState: 'quizComplete'
        })
      }
    })
  },
  getInitialState: function() {
    return {
      currentState: 'waitingForPlayer'
    };
  },
  renderQuizContent: function() {
    if(this.state.currentState === 'waitingForPlayer') {
      return <QuizWidgetIntro onStartButtonClick={this.onStartButtonClick} />
    } else if(this.state.currentState === 'gameStarted') {
      return <QuizWidgetGameScreen onQuizComplete={this.onQuizComplete}/>
    } else if(this.state.currentState === 'quizComplete') {
      return <QuizComplete/>
    }
  },
  render: function() {
    return (
      <div className='quiz-widget-wrapper'>
        <div className='quiz-widget-inner'>
          { this.renderQuizContent() }
        </div>
      </div>
    );
  }
});