/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
const HIGH_RATIO: number = 4.0;
const LOW_RATIO: number = 2.0;
const CRITICAL_RADIUS = 0.001;
const DEFAULT_STIFFNESS_RADIUS = 228.0;
const DEFAULT_DAMPING_RADIUS = 30.0;

export enum SpringModelType {
  CRITICAL_DAMPED, // critical damped calculation model
  UNDER_DAMPED, // under damped calculation model
  OVER_DAMPED // over damping calculation model
}

export class SpringProperty {
  // Default stiffness of spring.
  defaultStiffness: number = DEFAULT_STIFFNESS_RADIUS;
  // Default damping of spring.
  defaultDamping: number = DEFAULT_DAMPING_RADIUS;
  // Default mass of spring
  defaultMass: number = 1.0;
  // the mass of the spring.
  mass_: number = this.defaultMass;
  // the stiffness of spring, generally, a spring stiffness is constant.
  stiffness_: number = this.defaultStiffness;
  // damping ratio of spring
  damping_: number = this.defaultDamping;

  constructor(mass: number, stiffness: number, damping: number) {
    this.mass_ = mass;
    this.stiffness_ = stiffness;
    this.damping_ = damping;
  }

  setMass(mass: number): void {
    if (mass > 0.0) {
      this.mass_ = mass;
    }
  }

  mass(): number {
    return this.mass_;
  }

  setStiffness(stiffness: number): void {
    if (stiffness > 0.0) {
      this.stiffness_ = stiffness;
    }
  }

  stiffness(): number {
    return this.stiffness_;
  }

  setDamping(damping: number): void {
    if (damping > 0.0) {
      this.damping_ = damping;
    }
  }

  damping(): number {
    return this.damping_;
  }

  isValid(): boolean {
    if ((this.mass_ <= 0.0) || (this.stiffness_ <= 0.0) || (this.damping_ <= 0.0)) {
      return false;
    }
    return true;
  }
}

export abstract class SpringModel {
  // calculate position, the unit of time is second.
  abstract position(time: number): number;

  // calculate velocity, the unit of time is second.
  abstract velocity(time: number): number;

  // get current calculation type.
  abstract getType(): SpringModelType;

  /**
   * Judge the type of the spring and get the calculation according to the type.
   */
  public static build(distance: number, velocity: number, spring: SpringProperty): SpringModel {
    if (!spring || !spring.isValid()) {
      return undefined;
    }
    let cmk = spring.damping() * spring.damping() - HIGH_RATIO * spring.mass() * spring.stiffness();
    if (Math.abs(cmk) < CRITICAL_RADIUS) {
      if (Math.abs(distance) < CRITICAL_RADIUS) {
        return undefined;
      }
      return new CriticalDampedModel(distance, velocity, spring);
    }
    if (cmk > 0.0) {
      return new OverDampedModel(distance, velocity, spring);
    }
    return new UnderDampedModel(distance, velocity, spring);
  }
}

// Critical Damped calculation model.
export class CriticalDampedModel extends SpringModel {
  constructor(distance: number, velocity: number, spring: SpringProperty) {
    super();
    if (spring && spring.isValid() && Math.abs(distance) >= CRITICAL_RADIUS) {
      this.r_ = -spring.damping() / (LOW_RATIO * spring.mass());
      this.c1_ = distance;
      this.c2_ = velocity / (this.r_ * distance);
    }
  }

  position(time: number): number {
    return (this.c1_ + this.c2_ * time) * Math.exp(this.r_ * time);
  }

  velocity(time: number): number {
    let power = Math.exp(this.r_ * time);
    return this.r_ * (this.c1_ + this.c2_ * time) * power + this.c2_ * power;
  }

  getType(): SpringModelType {
    return SpringModelType.CRITICAL_DAMPED;
  }

  private r_: number = 0.0;
  private c1_: number = 0.0;
  private c2_: number = 0.0;
}

// OverDamping calculation model.
export class OverDampedModel extends SpringModel {
  constructor(distance: number, velocity: number, spring: SpringProperty) {
    super();
    if (spring && spring.isValid()) {
      let cmk = Math.sqrt(spring.damping() * spring.damping() - HIGH_RATIO * spring.mass() * spring.stiffness());
      let lowMass = LOW_RATIO * spring.mass();
      this.r1_ = (-spring.damping() - cmk) / lowMass;
      this.r2_ = (-spring.damping() + cmk) / lowMass;
      if (this.r2_ !== this.r1_) {
        this.c2_ = (velocity - this.r1_ * distance) / (this.r2_ - this.r1_);
        this.c1_ = distance - this.c2_;
      }
    }
  }

  position(time: number): number {
    return this.c1_ * Math.exp(this.r1_ * time) + this.c2_ * Math.exp(this.r2_ * time);
  }

  velocity(time: number): number {
    return this.c1_ * this.r1_ * Math.exp(this.r1_ * time) + this.c2_ * this.r2_ * Math.exp(this.r2_ * time);
  }

  getType(): SpringModelType {
    return SpringModelType.OVER_DAMPED;
  }

  private r1_: number = 0.0;
  private r2_: number = 0.0;
  private c1_: number = 0.0;
  private c2_: number = 0.0;
}


// UnderDamped calculation model
export class UnderDampedModel extends SpringModel {
  constructor(distance: number, velocity: number, spring: SpringProperty) {
    super();
    if (spring && spring.isValid()) {
      this.w_ = Math.sqrt(HIGH_RATIO * spring.mass() * spring.stiffness() - spring.damping() * spring.damping()) /
        (LOW_RATIO * spring.mass());
      this.r_ = -(spring.damping() / LOW_RATIO * spring.mass());
      this.c1_ = distance;
      if (Math.abs(this.w_) > CRITICAL_RADIUS) {
        this.c2_ = (velocity - this.r_ * distance) / this.w_;
      }
    }
  }


  position(time: number): number {
    let tmp = this.w_ * time;
    return Math.exp(this.r_ * time) * (this.c1_ * Math.cos(tmp) + this.c2_ * Math.sin(tmp));
  }

  velocity(time: number): number {
    let power = Math.exp(this.r_ * time);
    let tmp = this.w_ * time;
    let cosine = Math.cos(tmp);
    let sine = Math.sin(tmp);
    return power * (this.c2_ * this.w_ * cosine - this.c1_ * this.w_ * sine) +
      this.r_ * power * (this.c2_ * sine + this.c1_ * cosine);
  }

  getType(): SpringModelType {
    return SpringModelType.UNDER_DAMPED;
  }

  private w_: number = 0.0;
  private r_: number = 0.0;
  private c1_: number = 0.0;
  private c2_: number = 0.0;
}
