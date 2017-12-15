//
//  CustomAnimationPresentor.swift
//  InstagramClone
//
//  Created by Nuno Pereira on 15/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class CustomAnimationPresentor: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    
    //parametro transitionContext permite manipular a animacao
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //my custom transition animation code logic
        
        //a propriedade containerView de transitionContext e como se fosse a superView de todas as views envolvidas na animacao
        let containerView = transitionContext.containerView
        //a propriedade view de transitionContext para a key from, permite ter acesso a view ponto de partida da animacao
        guard let fromView = transitionContext.view(forKey: .from) else {return}
        //a propriedade view de transitionContext para a key to, permite ter acesso a view destino da animacao
        guard let toView = transitionContext.view(forKey: .to) else {return}
        
        //adicionar a toView a containerView para ser visualizada durante a animacao
        containerView.addSubview(toView)
        
        let startingFrame = CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
        
        toView.frame = startingFrame
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            //animation
            //Esta animacao ira determinar o ponto final da tela onde ira ficar a toView
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            //Esta animacao ira fazer com que a view de origem deslize ao longo do ecra em conjunto com a toView
            fromView.frame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
        }) { (_) in
            //Aqui e onde as animacoes ja terminaram e por isso faz sentido notificar aqui o sistema
            
            //Necessario chamar este metodo para notificar o sistema que a animacao terminou
            transitionContext.completeTransition(true)
        }
        
        
    }
}
