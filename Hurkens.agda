{-# OPTIONS --cumulativity #-}

open import Agda.Primitive

data ⊥ : Set where

U : ∀ ℓ ℓ₁ ℓ₂ → Set (lsuc (ℓ ⊔ ℓ₁ ⊔ ℓ₂))
U ℓ ℓ₁ ℓ₂ = ∀ (X : Set ℓ) → (((X → Set ℓ₁) → Set ℓ₂) → X) → ((X → Set ℓ₁) → Set ℓ₂) 

τ : ∀ ℓ₁ ℓ₂ → ((U ℓ₁ ℓ₁ ℓ₂ → Set ℓ₁) → Set ℓ₂) → U ℓ₁ ℓ₁ ℓ₂
τ ℓ₁ ℓ₂ t = λ X f p → t (λ x → p (f (x X f)))

σ : ∀ ℓ₁ ℓ₂ → U (lsuc (ℓ₁ ⊔ ℓ₂)) ℓ₁ ℓ₂ → (U ℓ₁ ℓ₁ ℓ₂ → Set ℓ₁) → Set ℓ₂
σ ℓ₁ ℓ₂ s = s (U ℓ₁ ℓ₁ ℓ₂) (τ ℓ₁ ℓ₂)

Δ : ∀ {ℓ₁ ℓ₂} → U (lsuc (ℓ₁ ⊔ ℓ₂)) ℓ₁ ℓ₂ → Set (lsuc (ℓ₁ ⊔ ℓ₂))
Δ {ℓ₁} {ℓ₂} y = (∀ p → σ ℓ₁ ℓ₂ y p → p (τ ℓ₁ ℓ₂ (σ ℓ₁ ℓ₂ y))) → ⊥

Ω : ∀ {ℓ} → U ℓ ℓ (lsuc (lsuc ℓ))
Ω {ℓ} = τ ℓ (lsuc (lsuc ℓ)) (λ p → (∀ x → σ ℓ ℓ x p → p x))

M : ∀ {ℓ} x → σ (lsuc ℓ) ℓ x (Δ {ℓ} {ℓ}) → Δ {lsuc ℓ} {ℓ} x
M {ℓ} _ 𝟚 𝟛 = 𝟛 Δ 𝟚 (λ p → 𝟛 (λ y → p (τ ℓ ℓ (σ ℓ ℓ y))))

R : ∀ {ℓ} p → (∀ x → σ ℓ (lsuc (lsuc ℓ)) x p → p x) → p Ω
R {ℓ} _ 𝟙 = {! 𝟙 (Ω {ℓ}) (λ x → 𝟙 (τ ℓ ℓ (σ ℓ ℓ x))) !}
-- Need Ω : U (lsuc (lsuc (lsuc ℓ))) ℓ (lsuc (lsuc ℓ))
-- Have Ω : U ℓ ℓ (lsuc (lsuc ℓ))

L : ∀ {ℓ} → (∀ p → (∀ x → σ ℓ (lsuc (lsuc ℓ)) x p → p x) → p Ω) → ⊥
L {ℓ} 𝟘 = {! 𝟘 (Δ {ℓ} {ℓ}) M (λ p → 𝟘 (λ y → p (τ ℓ ℓ (σ ℓ ℓ y)))) !}
-- Need Δ : U ℓ ℓ (lsuc (lsuc ℓ)) → Set ℓ
-- Have Δ : U (lsuc ℓ) ℓ ℓ → Set (lsuc ℓ)

false : ⊥
false = L {lzero} (R {lzero})