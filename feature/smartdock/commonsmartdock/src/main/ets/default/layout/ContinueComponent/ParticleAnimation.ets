/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'ParticleAnimation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);


@Component
export default struct ParticleAnimation {
  @Prop particleSize: number = 0;
  @Prop iconColor: number;

  private speed: number = 150 * 4.4 / px2vp(10);
  private positionX: number = this.particleSize / 2;
  private positionY: number = this.particleSize / 2;
  private partiCleDefaultColor: number = Color.Yellow;

  private getEmitter(emitterRadius: number, emitterCount: number): EmitterOptions<ParticleType> {
    log.showInfo(`particleSize is ${this.particleSize}}`);
    return {
      particle: {
        // 粒子类型
        type: ParticleType.POINT,
        config: {
          // 圆点半径
          radius: emitterRadius
        },
        // 粒子总数
        count: emitterCount,
        // 粒子生命周期，单位ms
        lifetime: 1000
      },
      // 每秒发射粒子数
      emitRate: 100,
      position: [this.positionX, this.positionY],
      // 发射器形状
      shape: ParticleEmitterShape.CIRCLE,
      size: ['0%', '0%']
    };
  }

  private getColor(): ParticleColorPropertyOptions<ParticleUpdater> {
    log.showInfo(`particleColor is ${this.iconColor}}`);
    return {
      // 初始颜色范围
      range: [Color.White, this.iconColor || this.partiCleDefaultColor]
    };
  }

  private getOpacity(delay: number, endMillis: number): ParticlePropertyOptions<number, ParticleUpdater> {
    return {
      // 粒子透明度的初始值从【0.5到1.0】随机产生
      range: [0.5, 1.0],
      updater: {
        // 透明的变化为曲线
        type: ParticleUpdater.CURVE,
        config: [
          {
            from: 0.0,
            to: 0.0,
            startMillis: 0,
            endMillis: 375 + delay,
            curve: Curve.EaseIn
          },
          {
            from: 0.7,
            to: 0.3,
            startMillis: 375 + delay,
            endMillis: 580 + delay,
            curve: Curve.EaseIn
          },
          {
            from: 0.3,
            to: 0.0,
            startMillis: 580 + delay,
            endMillis: endMillis,
            curve: Curve.EaseOut
          }
        ]
      }
    };
  }

  private getScale(): ParticlePropertyOptions<number, ParticleUpdater> {
    return {
      range: [0.1, 1.0],
      updater: {
        type: ParticleUpdater.CURVE,
        config: [
          {
            from: 1.0,
            to: 0.2,
            startMillis: 0,
            endMillis: 1000,
            curve: Curve.EaseOut
          }
        ]
      }
    };
  }

  build() {
    Particle({ particles: [
      {
        emitter: this.getEmitter(1.5, 5),
        color: { range: [Color.White, Color.White] },
        opacity: this.getOpacity(0, 850),
        scale: this.getScale(),
        velocity: {
          speed: [this.speed + 35, this.speed + 65],
          angle: [0, 360]
        }
      },
      {
        emitter: this.getEmitter(2, 5),
        color: { range: [Color.White, Color.White] },
        opacity: this.getOpacity(50, 900),
        scale: this.getScale(),
        velocity: {
          speed: [this.speed + 10, this.speed + 25],
          angle: [0, 360]
        }
      },
      {
        emitter: this.getEmitter(2.5, 6),
        color: this.getColor(),
        opacity: this.getOpacity(100, 950),
        scale: this.getScale(),
        velocity: {
          speed: [this.speed - 15, this.speed],
          angle: [0, 360]
        }
      }
    ]
    })
      .width(this.particleSize)
      .height(this.particleSize)
  }
}
