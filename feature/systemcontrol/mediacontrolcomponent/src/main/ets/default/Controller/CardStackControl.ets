/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
import Curves from '@ohos.curves';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';

const TAG: string = 'CardStackControl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

export class CardStackControl {
  // 动效相关参数

  // 动效初始参数
  public mediaBoxTranslate: number | string = 0; // 媒体卡片父盒子移动距离
  public mediaTranslate: number | string = 0; // 媒体卡片移动距离
  public devTranslate: number = 0; // 设备卡片移动距离
  public mediaCardScale: number = 1; // 卡片scale参数100%--90%
  public callCardScale: number = 1; // 卡片scale参数100%--90%
  public callBoxTranslate: number = 0; // 通话卡片父盒子移动距离
  public devScale: number = 0.8; // 设备卡片scale参数100%-80%
  public devRotateAngle: number = -60; // 设备卡片旋转度数
  public mediaBoxOpacity: number = 1; // 媒体卡片盒子透明度
  public cardBoxOpacity: number = 1; // 通话卡片盒子透明度
  public stackTopOpacity: number = 0; // 堆叠顶部透明度
  public stackTopTranslate: number = 1; // 堆叠顶部移动距离
  public devOpacity: number = 0; // 设备卡片透明度
  public callTranslate: number | string = 0; // 通话卡片移动距离
  public startPosition: number = 0; // 记录手势按下的位置，即开始位置
  public distance: number = 0; // 跟手动效卡片的移动距离
  public moveScreen: number = 296;

  // 动效目标参数
  public mediaTargetScale: number = 0.9; // 卡片scale参数100%--90%
  public callTargetScale: number = 0.9; // 卡片scale参数100%--90%
  public devTargetScale: number = 0.8; // 设备卡片scale参数100%-50%
  public devTargetAngle: number = -60; // 设备卡片旋转度数
  public devTargetTranslate: number = -200; // 设备卡片移动距离
  public devTargetOpacity: number = 1; // 设备卡片透明度
  public stackTopTargetOpc: number = 0.8; // 堆叠顶部透明度
  public stackTopTargetTranslate: number = 12; // 堆叠顶部移动距离

  // 卡片/动效相关状态
  public isMediaUp: boolean = false; // 是否是媒体卡片在上
  public isCallUp: boolean = false; // 是否为通话卡片在上
  public animatedStatus: boolean = false; // 跟手动效动画状态
  public moveUpArray: Array<number> = []; // 处理手势上滑的坐标数组
  public isMoveUp: boolean = false; // 是否为手势上滑
  public isLandscape:boolean = false;
  public portraitParams:number = 0;
  public isMove:boolean = false;
  public mediaCardStatus:boolean = false;
  public callCardStatus:boolean = false;
  public isTouchMove:boolean = false;
  public isClick:boolean = false;
  public ediaIndex:number = 10;
  public callIndex:number = 10;
  public showDevFalseTimer:null | number = null;
  public hasCall:boolean = false;
  public mediaH:number = 0;
  public callH:number = 0;

  public moveInit(coordinates: number, isMedia: number, isCall: number, isLandscape: boolean) {
    this.isLandscape = isLandscape
    this.portraitParams = !this.animatedStatus ? isMedia : isCall
    this.moveScreen = this.isLandscape ? 296 : this.portraitParams
    this.distance = (coordinates) - this.startPosition;
    this.isTouchMove = true
  }

  public clickInit(isStack: boolean = false, isLandscape: boolean, hasCall: boolean, mediaH: number, callH: number) {
    this.isLandscape = isLandscape
    this.hasCall = hasCall
    this.mediaH = mediaH
    this.callH = callH
    if (this.hasCall) {
      this.UpStack(isStack)
    }
  }

  public UpStack(isStack: boolean, isIndexUse: boolean = false) {
    this.isTouchMove = false
    this.mediaTranslate = isStack ? (this.isLandscape ? (this.isCallUp ? '-55%' : '-110%') :
      (this.isCallUp ? -this.mediaH + 9 : -this.callH - 12)) : 0 // 媒体卡片、设备卡片移动参数
    this.callBoxTranslate = isStack ? -18 : 0
    this.devTranslate = isStack ? this.devTargetTranslate : 0
    this.callCardScale = isStack && !this.isCallUp ? this.callTargetScale : 1
    this.mediaCardScale = isStack && this.isCallUp ? this.mediaTargetScale : 1
    this.devRotateAngle = isStack ? 0 : this.isLandscape ? -this.devTargetAngle : this.devTargetAngle
    this.devOpacity = isStack ? this.devTargetOpacity : 0
    this.devScale = isStack ? 1 : this.devTargetScale
    this.mediaBoxOpacity = isStack && !this.isMediaUp ? 0 : 1
    this.callTranslate = isStack ? this.isCallUp ? 0 : -20 : 0
    this.callBoxTranslate = isStack ? (this.isLandscape ? 98 : 0) : 0
    this.cardBoxOpacity = isStack ? this.isCallUp ? 1 : 0 : 1
    this.stackTopOpacity = isStack ? this.stackTopTargetOpc : 0
    this.stackTopTranslate = isStack ?
      this.isLandscape ? -this.stackTopTargetTranslate - 16 : -this.stackTopTargetTranslate :
      this.isMediaUp ? 0 : this.stackTopTargetTranslate
    log.showInfo(`StackTopTranslateClickParams-${this.hasCall}, MediaTranslateClickParams-${this.isLandscape}`);
  }


  // 手势移动时的处理
  touchMove(movePosition: number, isLandscape: boolean) {
    if (movePosition <= this.moveUpArray[0]) {
      log.showInfo(`movePosition not large than array: ${movePosition} / ${this.moveUpArray[0]}`);
      return;
    }
    if (this.distance > 0) {
      if (this.isMoveUp) {
        this.isMoveUp = false;
      }
      if (this.distance < this.moveScreen) {
        this.stackTopOpacity = 0;
        this.stackTopTranslate = 0;
        if (!this.animatedStatus) {
          this.LessThanMoveScreenCall(isLandscape);
          this.DownDevLessThanHeight(isLandscape ? 72 : 32, isLandscape);
        } else {
          this.LessThanMoveScreenMedia();
          this.DownDevLessThanHeight(isLandscape ? 68 : 18, isLandscape);
        }
        log.showInfo(`isCallUp/isMediaUp ${this.isCallUp} / ${this.isMediaUp}`);
      }
      if (this.distance > this.moveScreen) {
        this.devRotateAngle = this.devTargetAngle;
        this.devOpacity = 0;
        this.devScale = this.devTargetScale;
        if (this.animatedStatus) {
          this.isCallUp = true;
          this.isMediaUp = false;
        } else {
          this.isCallUp = false;
          this.isMediaUp = true;
        }
        this.BoxClipStatus()
        log.showInfo(`isCallUp/isMediaUp ${this.isCallUp} / ${this.isMediaUp}`);
        this.doTouchMoveProcess(isLandscape);
      }
    }
  }

  private doTouchMoveProcess(isLandscape: boolean): void {
    if (this.animatedStatus) {
      this.mediaTranslate = -((this.distance)) + (this.moveScreen);
      this.mediaCardScale = 1 - ((-this.mediaTranslate / this.moveScreen) * (1 - this.mediaTargetScale));
      this.mediaBoxOpacity = 1 - (-this.mediaTranslate / (this.moveScreen + 45));
      this.devTranslate = (isLandscape ? -12 : 12) - (((-this.mediaTranslate) / 188) * 188);
      this.devRotateAngle = isLandscape ? -(this.devTargetAngle + ((-this.mediaTranslate / this.moveScreen) *
        (-this.devTargetAngle))) : this.devTargetAngle + ((-this.mediaTranslate / this.moveScreen) *
        (-this.devTargetAngle));
      this.devOpacity = (-this.mediaTranslate / this.moveScreen);
      this.devScale = this.devTargetScale + ((-this.mediaTranslate / this.moveScreen) *
        (1 - this.devTargetScale));
    } else {
      this.callTranslate = this.moveScreen - ((this.distance) - this.moveScreen);
      this.callCardScale = 1 - (((this.moveScreen - this.callTranslate) / this.moveScreen) *
        (1 - this.callTargetScale));
      this.cardBoxOpacity = (this.callTranslate / this.moveScreen);
      this.devTranslate = (-88 - (((this.callTranslate < (-this.devTargetTranslate) ?
        (-this.devTargetTranslate) - this.callTranslate : 0) / 112) * 112));
      this.devRotateAngle = isLandscape ? -(this.devTargetAngle +
        ((1 - (this.callTranslate / this.moveScreen)) * (-this.devTargetAngle))) : this.devTargetAngle +
        ((1 - (this.callTranslate / this.moveScreen)) * (-this.devTargetAngle));
      this.devOpacity = 1 - (this.callTranslate / this.moveScreen);
      this.devScale = this.devTargetScale + ((1 - (this.callTranslate / this.moveScreen)) *
        (1 - this.devTargetScale));
    }

    if ((-(this.distance) + this.moveScreen) <= -this.moveScreen) {
      this.callTranslate = this.isCallUp ? 0 : -20;
      this.devTranslate = this.devTargetTranslate;
      this.mediaTranslate = isLandscape ? -this.moveScreen - 36 :
        !this.animatedStatus ? -this.moveScreen - 16 : -this.moveScreen - 16;
      this.mediaCardScale = this.isMediaUp ? 1 : this.mediaTargetScale;
      this.callCardScale = this.isCallUp ? 1 : this.callTargetScale;
      this.mediaBoxOpacity = this.isMediaUp ? 1 : 0;
      this.cardBoxOpacity = this.isCallUp ? 1 : 0;
      this.devRotateAngle = 0;
      this.devOpacity = 1;
      this.devScale = 1;
      this.stackTopOpacity = 1;
      this.stackTopTranslate = -this.stackTopTargetTranslate;
    }
  }


  // 手势上滑时的坐标处理
  public MoveArray(movePosition: number) {
    this.moveUpArray.push(movePosition)
    if (this.isMoveUp) {
      return
    }
    if (this.moveUpArray.length > 5) {
      this.moveUpArray.splice(0, 5)
      this.moveUpArray.push(movePosition)
    }
    for (let i: number = 0; i < this.moveUpArray.length; i++) {
      if (this.moveUpArray[i] > this.moveUpArray[i + 1]) {
        this.moveUpArray[0] = this.moveUpArray[i]
        this.isMoveUp = true
        this.moveUpArray.splice(1)
        break
      }

    }
  }

  // 移动距离小于卡片宽高时通话卡片的处理
  public LessThanMoveScreenCall(isLandscape: Boolean) {
    this.mediaTranslate = isLandscape ?
      -this.moveScreen - ((54 - ((this.distance / this.moveScreen) * 38)) <= 16 ?
        16 : (54 - ((this.distance / this.moveScreen) * 38))) :
      -this.moveScreen + ((12 + ((this.distance / this.moveScreen) * 21)) >= 33 ?
        33 : (12 + ((this.distance / this.moveScreen) * 21)))

    this.mediaCardScale = this.mediaTargetScale + (((this.distance) / this.moveScreen) * (1 - this.mediaTargetScale))
    this.callTranslate = this.distance
    this.mediaBoxOpacity = (this.distance * 3) / this.moveScreen
    log.showInfo(`LessThanMoveScreenCall--${this.mediaTranslate}`)
  }

  // 移动距离小于卡片宽高时媒体卡片的处理
  public LessThanMoveScreenMedia() {
    this.callCardScale = this.callTargetScale + (((this.distance) / this.moveScreen) * (1 - this.callTargetScale))
    this.callTranslate = -20 + (((this.distance) / this.moveScreen) * 20)
    this.mediaTranslate = (-this.moveScreen - (this.isLandscape ? 32 : 0)) + this.distance
    this.cardBoxOpacity = (this.distance * 3) / this.moveScreen
    log.showInfo(`LessThanMoveScreenMedia--${this.mediaTranslate}`)

  }

  // 下滑未超过卡片高度时的设备卡片的移动距离
  public DownDevLessThanHeight(distance: number, isLandscape: boolean) {
    if (this.distance > distance) {
      this.devTranslate = (this.distance - distance) - (-this.devTargetTranslate)
      this.devRotateAngle = isLandscape ? ((this.distance - distance) / (-this.devTargetTranslate)) *
        (-this.devTargetAngle) : (-(this.distance - distance) / (-this.devTargetTranslate) * (-this.devTargetAngle))
      this.devOpacity = (1 - ((this.distance - distance) / (-this.devTargetTranslate))) <= 0 ? 0 : 1 -
        ((this.distance - distance) / (-this.devTargetTranslate))
      this.devScale = (1 - (((this.distance - distance) / (-this.devTargetTranslate)) *
      this.devTargetScale)) <= this.devTargetScale ? this.devTargetScale : 1 - (((this.distance - distance) /
        (-this.devTargetTranslate)) * this.devTargetScale)
    }

  }
  TouchUp() {
    this.moveUpArray = []
    animateTo({
      curve: Curves.springMotion(),
      onFinish: () => {
        this.isTouchMove = false
      }
    }, () => {
      this.TouchUpParams()
    })
    this.animatedStatus = false
    this.isMoveUp = false
    log.showInfo(`TouchUpAnimatedStatus${this.animatedStatus}----${this.isMoveUp}`)
  }
  // 手指离去时的卡片参数处理
  public TouchUpParams() {
    let mediaExtras: number = this.isMediaUp ? 29 : 12
    this.callTranslate = this.isCallUp ? 0 : -20
    this.devTranslate = this.devTargetTranslate
    this.mediaTranslate = this.isLandscape ? (-this.moveScreen - (!this.isMediaUp ? 54 : 32)) :
      (!this.animatedStatus ? -this.moveScreen + mediaExtras : -this.moveScreen - (this.isMediaUp ? 12 : 33))
    this.mediaCardScale = this.isMediaUp ? 1 : this.mediaTargetScale
    this.callCardScale = this.isCallUp ? 1 : this.callTargetScale
    this.mediaBoxOpacity = this.isMediaUp ? 1 : 0
    this.cardBoxOpacity = this.isCallUp ? 1 : 0
    this.devRotateAngle = 0
    this.devOpacity = 1
    this.devScale = 1
    this.stackTopOpacity = 1
    this.stackTopTranslate = this.isLandscape ? -this.stackTopTargetTranslate - 16 : -this.stackTopTargetTranslate
    log.showInfo(`MediaTranslateTouchUpParams---${this.mediaTranslate}---${this.animatedStatus}`)
  }
  // 手势按下时的相关状态处理
  TouchDown(coordinates: number) {
    if (!this.isCallUp && this.isMediaUp) {
      this.animatedStatus = true
    }
    if (this.isCallUp && !this.isMediaUp) {
      this.animatedStatus = false
    }
    this.startPosition = coordinates

  }

  // 解决重叠透明
  BackBoxHeight(height: string | number, distance: number) {
    let cardHeight: number = Number((height + '').substring(0, 3))
    let cardDistance: number = Math.abs(distance)
    log.showInfo(`BackBoxHeight---${cardHeight - cardDistance} && ${cardHeight} && ${cardDistance}`)
    if (cardDistance == 0) {
      return cardHeight
    } else {
      return cardHeight - cardDistance
    }
  }

  BoxClipStatus() {
    if (this.isMediaUp && !this.isCallUp) {
      this.mediaCardStatus = false
      this.callCardStatus = true
    } else if (this.isCallUp && !this.isMediaUp) {
      this.mediaCardStatus = true
      this.callCardStatus = false
    } else if (!this.isMediaUp && !this.isCallUp) {
      this.mediaCardStatus = false
      this.callCardStatus = false
    }
    log.showInfo(`BoxClipStatus: ${this.mediaCardStatus}, ${this.isMediaUp}, ${this.isCallUp}`)
  }
}