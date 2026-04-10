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
import curves from '@ohos.curves';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { PCUtils } from '../../../common/utils/PCUtils';
import Constants from '../common/Constants';
import { AccountsComponentStyle } from '../common/StyleConfiguration';
import AccountsViewModel from '../vm/AccountsViewModel';

const TAG = 'ScreenLock-Emoji-Components'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const EMOJI_STATE_OBSERVING = 0;
const EMOJI_STATE_BLINDED = 1;
const EMOJI_STATE_REMEMBERING = 2;

const FOCUS_CHANGE = 0;
const CONTENT_CHANGE = 1;
const AUTH_CHANGE = 2;

const MAX_RADIUS = 300;
const MAX_REMEMBER_TIMES = 2;

@Component
export default struct EmojiComponent {
  @State
  transYForHand: number = 25;
  @State
  alphaForHand: number = 0.0;
  @State
  transXForEye: number = 0.0;
  @State
  transYForEye: number = 0.0;
  @State
  scaleForEye: number = 1.0;
  @State
  scaleForEyeBg: number = 1.0;
  @State
  transYForEyeBg: number = 0.0;
  @State
  scaleForMouse: number = 1.0;
  @State
  transYForMouse: number = 0.0;
  private thinkingImages: Array<ImageFrameInfo> = [];
  @State
  thinkingNeedReverse: boolean = false;
  @State
  thinkingAnimateState: AnimationStatus = AnimationStatus.Initial;
  @State
  thinkingAlpha: number = 0.0;
  @State
  isRunThinking: Boolean = false;
  @StorageLink('isEmojiOnFocus') @Watch('onFocusChange')
  isEmojiOnFocus: boolean = false;
  @StorageLink('isEmojiHasContent') @Watch('onContentChange')
  isEmojiHasContent: number = 0;
  @StorageLink('isEmojiAuthSuccess') @Watch('onAuthChange')
  isEmojiAuthSuccess: string = 'WAIT_AUTH';
  @StorageLink('emojiMouseEvent') @Watch('onMouseEvent')
  mouseEvent: Position = {x: 0, y: 0};
  @Consume
  isPowerMenuPanelShowed: boolean;
  private anchorX: number = 0;
  private anchorY: number = 0;
  private currentState: number = EMOJI_STATE_OBSERVING;
  private allowInterrupt: boolean = true;
  private isFirstMouseEvent: boolean = true;
  private isAnchorInit: boolean = false;
  private rememberTimes: number = 0;
  private accountsStyle: AccountsComponentStyle | null = null;

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    for (let index = 0; index <= 40; index++) {
      let imagePath = 'emoji/demo/thinking/emoji_' + index + '.png';
      let frameInfo: ImageFrameInfo = {
        src: $rawfile(imagePath)
      }
      this.thinkingImages.push(frameInfo);
    }
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  private resetFace(): void {
    this.scaleForEye = 1.0;
    this.transXForEye = 0.0;
    this.transYForEye = 0.0;
    this.scaleForEyeBg = 1.0;
    this.transYForEyeBg = 0.0;
    this.scaleForMouse = 1.0;
    this.transYForMouse = 1.0;
  }

  private runHandAnimate(show: boolean): void {
    log.showInfo('runHandAnimate');
    this.resetFace();
    animateTo({
      duration: 1000,
      curve: Curve.Friction
    }, () => {
      this.alphaForHand = show ? 1.0 : 0.0;
      this.transYForHand = show ? 0.0 : 25;
      log.showInfo(`alphaForHand: ${this.alphaForHand}, transYForHand: ${this.transYForHand}`);
    })
  }

  private runThinkingAnimate(show: boolean): void {
    log.showInfo('runThinkingAnimate');
    animateTo({
      duration: 1200,
      curve: Curve.Friction
    }, () => {
      this.thinkingAlpha = show ? 1.0 : 0.0;
    })
    if (show) {
      animateTo({
        duration: 0,
        delay: 1000
      }, () => {
        this.thinkingAnimateState = AnimationStatus.Running;
      })
    } else {
      this.thinkingAnimateState = AnimationStatus.Paused;
    }
  }

  updateEmojiState(changeReason : number): number {
    log.showInfo(`updateEmojiState changeReason: ${changeReason}, currentState: ${this.currentState},  Focus: ${this.isEmojiOnFocus},
       Content: ${this.isEmojiHasContent}, Auth: ${this.isEmojiAuthSuccess}`);
    if (changeReason === FOCUS_CHANGE) {
      if (!this.isEmojiOnFocus) {
        return EMOJI_STATE_OBSERVING;
      }
    } else if (changeReason === CONTENT_CHANGE) {
      if (this.isEmojiHasContent > 0) {
        return EMOJI_STATE_BLINDED;
      } else if (this.isEmojiHasContent === 0 && this.currentState === EMOJI_STATE_BLINDED) {
        return EMOJI_STATE_OBSERVING;
      }
    } else if (changeReason === AUTH_CHANGE) {
      if (this.currentState !== EMOJI_STATE_REMEMBERING) {
        if (this.isEmojiAuthSuccess === 'AUTH_SUCC') {
          return EMOJI_STATE_OBSERVING; //解锁，并重置到默认状态
        } else if (this.isEmojiAuthSuccess === 'AUTH_FAIL') {
          return EMOJI_STATE_REMEMBERING;
        }
      }
    }
    return this.currentState;
  }

  onAuthChange() {
    if (this.isEmojiAuthSuccess === undefined || this.isEmojiAuthSuccess === 'WAIT_AUTH') {
      return;
    }
    let newState = this.updateEmojiState(AUTH_CHANGE);
    if (newState !== this.currentState) {
      this.currentState = newState;
      if (this.currentState === EMOJI_STATE_REMEMBERING) {
        this.allowInterrupt = false;
        this.rememberTimes = 0;
      }
      this.onEmojiStateChange();
    }
    this.isEmojiAuthSuccess = 'WAIT_AUTH';
  }

  onContentChange() {
    if (this.isEmojiHasContent === undefined || this.isEmojiHasContent < 0) {
      return;
    }
    let newState = this.updateEmojiState(CONTENT_CHANGE);
    if (newState !== this.currentState) {
      this.currentState = newState;
      this.onEmojiStateChange();
    }
  }

  onFocusChange() {
    if (this.isEmojiOnFocus === undefined) {
      return;
    }
    let newState = this.updateEmojiState(FOCUS_CHANGE);
    if (newState !== this.currentState) {
      this.currentState = newState;
      this.onEmojiStateChange();
    }
  }

  onEmojiStateChange() {
    setTimeout(() => {
      if (!this.allowInterrupt && this.currentState != EMOJI_STATE_REMEMBERING) {
        log.showInfo(`Do not alow interrupt remembering animation: ${this.allowInterrupt}`);
        return;
      }

      this.isRunThinking = this.currentState == EMOJI_STATE_REMEMBERING ? true : false;

      if (this.currentState === EMOJI_STATE_OBSERVING) {
        this.runHandAnimate(false);
        this.runThinkingAnimate(false);
      } else if (this.currentState === EMOJI_STATE_BLINDED) {
        this.runHandAnimate(true);
        this.runThinkingAnimate(false);
      } else if (this.currentState === EMOJI_STATE_REMEMBERING) {
        this.runHandAnimate(false);
        this.runThinkingAnimate(true);
      }
    })
  }

  onMouseEvent() {
    if (!this.isAnchorInit) {
      return;
    }
    if (this.isFirstMouseEvent) {
      this.isFirstMouseEvent = false; //过滤第一次鼠标事件，防止表情初始眼睛位置不对
      return;
    }
    let pos: Position | undefined = AppStorage.get('emojiMouseEvent');
    if (pos === undefined || this.currentState > EMOJI_STATE_OBSERVING) {
      return;
    }
    const currX: number = Number(pos.x);
    const currY: number = Number(pos.y);
    let flag = currX < this.anchorX ? -1 : 1;
    let dx = Math.abs(this.anchorX - currX);
    let dy = Math.abs(this.anchorY - currY);
    let currDistance: number = Math.sqrt(Math.pow(currX - this.anchorX, 2.0) + Math.pow(currY - this.anchorY, 2.0));
    if (currDistance > MAX_RADIUS) {
      let ratio: number = MAX_RADIUS / currDistance;
      dx = dx * ratio;
      dy = dy * ratio;
    }

    if (currY <= this.anchorY) {
      const maxX = 5;
      const maxY = -5;
      let translateX: number = (dx / MAX_RADIUS) * maxX * flag;
      let translateY: number = (dy / MAX_RADIUS) * maxY;
      animateTo({
        curve: curves.responsiveSpringMotion()
      }, () => {
        this.transXForEye = translateX;
        this.transYForEye = translateY;
      })
    } else {
      let scaleForEye = 1.0 + (dy / MAX_RADIUS) * 0.2;
      let transXForEye = (dx / MAX_RADIUS) * 4 * flag;
      let transYForEye = (dy / MAX_RADIUS) * 9;
      let scaleForEyeBg = 1.0 + (dy / MAX_RADIUS) * 0.3;
      let transYForEyeBg = (dy / MAX_RADIUS) * 10;
      let scaleForMouse = 1.0 - (dy / MAX_RADIUS) * 0.6;
      let transYForMouse = (dy / MAX_RADIUS) * 10.0;
      animateTo({
        curve: curves.responsiveSpringMotion()
      }, () => {
        this.scaleForEye = scaleForEye;
        this.transXForEye = transXForEye;
        this.transYForEye = transYForEye;
        this.scaleForEyeBg = scaleForEyeBg;
        this.transYForEyeBg = transYForEyeBg;
        this.scaleForMouse = scaleForMouse;
        this.transYForMouse = transYForMouse;
      })
    }
  }

  build() {
    Stack() {
      if (PCUtils.is2D() || AccountsViewModel.getInstance().selectedUserId === Constants.INVALID_USER_ID) {
        Image($rawfile('emoji/demo/base/face_bg.png')).autoResize(false).draggable(false)
          .interpolation(ImageInterpolation.Medium)
        Image($rawfile('emoji/demo/base/eye_bg.png')).autoResize(false).draggable(false)
          .interpolation(ImageInterpolation.Medium)
        Image($rawfile('emoji/demo/base/eye.png')).autoResize(false).draggable(false)
          .interpolation(ImageInterpolation.Medium)
        Image($rawfile('emoji/demo/base/mouse.png')).autoResize(false).draggable(false)
          .interpolation(ImageInterpolation.Medium)
      } else {
        Stack() {
          Image($rawfile('emoji/demo/base/face_bg.png')).autoResize(false).draggable(false)
            .interpolation(ImageInterpolation.Medium)
          Image($rawfile('emoji/demo/base/eye_bg.png')).autoResize(false).draggable(false)
            .interpolation(ImageInterpolation.Medium)
            .scale({x: this.scaleForEyeBg, y: this.scaleForEyeBg, centerX: '50%', centerY: '50%'})
            .translate({y: this.transYForEyeBg})
          Image($rawfile('emoji/demo/base/eye.png')).autoResize(false).draggable(false)
            .interpolation(ImageInterpolation.Medium)
            .scale({x: this.scaleForEye, y: this.scaleForEye, centerX: '50%', centerY: '50%'})
            .translate({x: this.transXForEye, y: this.transYForEye})
          Image($rawfile('emoji/demo/base/mouse.png')).autoResize(false).draggable(false)
            .interpolation(ImageInterpolation.Medium)
            .scale({x: this.scaleForMouse, y: this.scaleForMouse, centerX: '50%', centerY: '50%'})
            .translate({y: this.transYForMouse})
          Image($rawfile('emoji/demo/base/hand.png')).autoResize(false).draggable(false)
            .interpolation(ImageInterpolation.Medium)
            .translate({y: this.transYForHand})
            .opacity(this.alphaForHand).onAreaChange((oldValue, newValue) => {
            let x: number = Number(newValue.globalPosition.x);
            let y: number = Number(newValue.globalPosition.y);
            log.showInfo(`emoji hand area change PosX:  + ${x},  PosY: ${y} , transYForHand: ${this.transYForHand}`);
          })
        }.visibility(!this.isRunThinking ? Visibility.Visible : Visibility.Hidden)

        if (this.isRunThinking) {
          ImageAnimator().images(this.thinkingImages).iterations(1)
            .reverse(this.thinkingNeedReverse)
            .onFinish(() => {
              this.rememberTimes += 1;
              this.thinkingNeedReverse = !this.thinkingNeedReverse;
              if (this.rememberTimes >= MAX_REMEMBER_TIMES) {
                this.rememberTimes = 0;
                this.allowInterrupt = true;
                if (this.currentState === EMOJI_STATE_REMEMBERING) {
                  this.currentState = EMOJI_STATE_OBSERVING;
                }
                this.onEmojiStateChange();
              }
            })
            .draggable(false)
            .duration(1000)
            .fillMode(FillMode.Both)
            .state(this.thinkingAnimateState)
            .width('140%')
            .height('140%')
            .opacity(this.thinkingAlpha)
        }
      }
    }
    .id(Constants.KEY_USER_ICON)
    .width(this.accountsStyle?.userIconWidth)
    .height(this.accountsStyle?.userIconHeight)
    .borderRadius(this.accountsStyle?.userIconRadius)
    .onAreaChange((oldValue, newValue) => {
      this.isAnchorInit = true;
      const x: number = Number(newValue.globalPosition.x);
      const y: number = Number(newValue.globalPosition.y);
      const width: number = Number(newValue.width);
      const height: number = Number(newValue.height);
      this.anchorX = x + width / 2.0;
      this.anchorY = (y + height / 2.0) + 260;
      log.showInfo(`emoji area change width:${width},height:${height},anchorX:${this.anchorX},anchorY:${this.anchorY}`);
    })
  }
}