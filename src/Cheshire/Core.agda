{-# OPTIONS --safe #-}

module Cheshire.Core where

module 𝕃 where
  open import Level renaming (Level to t) public

module 𝟙 where
  open import Data.Unit.Polymorphic renaming (⊤ to t) public

module Rel₁ where
  open import Relation.Unary hiding (∅; U) public
  open import Relation.Unary.Polymorphic public

module Rel₂ where
  open import Relation.Binary public
  open import Relation.Binary.PropositionalEquality public
  import Relation.Binary.Reasoning.Setoid as SetoidR
  module SetoidReasoning {s₁ s₂} (S : Setoid s₁ s₂) = SetoidR S

open 𝕃 using (_⊔_) public
open Rel₂ using (Rel) public

record Quiver o ℓ : Set (𝕃.suc (o ⊔ ℓ)) where
  no-eta-equality
  constructor mk⇒
  infix 4 _⇒_
  field
    {Ob} : Set o
    _⇒_ : Rel Ob ℓ

private
  variable
    o ℓ : 𝕃.t

module _ (𝒬 : Quiver o ℓ) where

  open Quiver 𝒬

  private
    variable
      A B : Ob

  record Equivalence (e : 𝕃.t) : Set (o ⊔ ℓ ⊔ 𝕃.suc e) where
    infix  4 _≈_
    field
      _≈_ : ∀ {A B} → Rel (A ⇒ B) e
      equiv : ∀ {A B} → Rel₂.IsEquivalence (_≈_ {A} {B})

    setoid : {A B : Ob} → Rel₂.Setoid ℓ e
    setoid {A} {B} = record
      { Carrier       = A ⇒ B
      ; _≈_           = _≈_
      ; isEquivalence = equiv
      }

    module Equiv {A B : Ob} = Rel₂.IsEquivalence (equiv {A} {B})
    module EdgeReasoning {A B : Ob} = Rel₂.SetoidReasoning (setoid {A} {B})

module Isomorphism (𝒬 : Quiver o ℓ) where

  open Quiver 𝒬

  infix 4 _≅_
  record _≅_ (A B : Ob) : Set (o ⊔ ℓ) where
    field
      from : A ⇒ B
      to   : B ⇒ A
