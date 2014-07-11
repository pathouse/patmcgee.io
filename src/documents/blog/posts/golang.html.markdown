---
title: "Groking Concurrency in Go"
date: 2014-07-10
---

## Golang

<!-- begin summary -->

I started learning Go recently. Today I had my first "aha!" moment reguarding it's concurrency primitives and just needed to write a post about it.
**Spoiler Alert** what follows is the solution to one of the last exercises in the [Go Tour](http://tour.golang.org/) so read no further if you
plan on completing it yourself.

<!-- read more -->

Starting with Chapter 71 of the tour, Binary Trees are introduced and you are asked to concurrently compare two of them to determine whether
they are equivalent.

The tree struct is defined:

    type Tree struct {
        Left  *Tree
        Value int
        Right *Tree
    }


You're also handed a empty skeleton of functions to define to solve the problem:


    package main

    import "code.google.com/p/go-tour/tree"

    // Walk walks the tree t sending all values
    // from the tree to the channel ch.
    func Walk(t *tree.Tree, ch chan int)

    // Same determines whether the trees
    // t1 and t2 contain the same values.
    func Same(t1, t2 *tree.Tree) bool

    func main() {
    }


At first I was unsure how to even implement the Walk function. I haven't thought about Binary trees for 3 years - since I was a junior in college.
Luckily, traversing a tree is one of those beautiful CS problems with an implementation that becomes obvious when you just say the steps you need to take out loud to yourself. Another victory to Rubber Ducky debugging.

For any given node in the tree, you want to first return the values of all nodes to the left, then it's own value, then the value of all nodes to the
right. At least that's the case if its a sorted tree and you want to return the values from least to greatest, which are both true here.

So Walk's implementation is exactly that. Walk left if you can, return the current value (or send it to the channel in this instance), Walk right if you can.

    func Walk(t *tree.Tree, ch chan int) {
	    if t.Left != nil {
            Walk(t.Left, ch)
        }

       ch <- t.Value

       if t.Right != nil {
	       Walk(t.Right, ch)
	   }
    }

Now that I had traversal working, I had to tackle the concurrency part. Go makes this incredibly easy. At first I was confused and felt I had
no intuitive sense of what was happening. My feeling was similar to my first encounter with asynchronous programming in Javascript. Once having
conquered a problem like that, it's easy to look back and think - that feeling of abject terror and disorientation is a good thing because it means
I'm about to learn. Unfortunately, in the moment it often just feels like abject terror and disorientation.

Moving from the "this, then this, then this, then that", model of thinking about programming to the,
"these things at the same time, and this stuff as the results become available" model is a pretty profound change. It took me a number of tries
and I kept on going back through the first couple of examples. The [Go Playground](http://play.golang.org/) really came in handy.

At some point, it just clicked, and the floodgates opened. It was one of those moments that reminds me why I love coding so much. Suddenly,
the world had changed a little bit, and I found myself going back over problems I had worked on in the past, armed with this new
understanding of how to employ a concurrent solution. Here's my implementation of the `Same` method:

    // Same determines whether the trees
    // t1 and t2 contain the same values.
    func Same(t1, t2 *tree.Tree) bool {
	    ch1 := make(chan int)
	    ch2 := make(chan int)
	    go Walk(t1, ch1)
	    go Walk(t2, ch2)
	    for i := 0; i < 10; i++ {
		    v1, v2 := <-ch1, <-ch2
		    if v1 != v2 {
			    return false
            }
	    }
	    return true
    }

Now, in this solution, I was able to finally grok the way that goroutines are able to use channels
to communicate with the "outside world" while running. I still have a lot to learn in this respect, and this is by no means
a perfect solution, but it's an important first step. A critical step in fact, since I doubt that I'd be able to understand
why better solutions are indeed better if I hadn't written this one myself first. 

Writing this post has helped too. Publishing my excitement on the internet made me think twice about how correct my solution was
and how sound my grasp of the concepts was, so I looked up other answers and dug deeper into the concurrency documentation. Lo and behold,
my solution isn't as great as I thought it was (I leaned pretty heavily on the fact that I was guaranteed to only have trees of length 10 for instance)
and I've only just scratched the surface of channels and goroutines. Time to learn more. 
