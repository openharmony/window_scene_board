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

import toggleHomePresenter from '../common/presenter/ToggleHomePresenter';
import StyleConstants from '../common/constants/StyleConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { sSCBOobeManager } from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import Curves from '@ohos.curves';

const TAG = 'ToggleHome';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const HOME_KEY = 'h1_launcher_feature_toggleHome_showDesktop';
const WGR_SVG: string = 'M27,0 C28.6568542,0 30,1.34314575 30,3 C30,17.9116882 17.9116882,30 3,30 C1.34314575,30 0,28.6568542 0,27 C0,25.3431458 1.34314575,24 3,24 C14.5979797,24 24,14.5979797 24,3 C24,1.34314575 25.3431458,0 27,0 Z';
const KLV_SVG: string = 'M22.9651163,0 C24.0327598,0 24.9083632,0.822221248 24.9932544,1.86799162 L25,2.03488372 L25,11.0400688 L24.993569,11.9146512 C24.9394085,15.4215953 24.5360825,17.2604377 23.5170259,19.1659079 C22.5166445,21.0364585 21.0364585,22.5166445 19.1659079,23.5170259 C17.2604377,24.5360825 15.4215953,24.9394085 11.9146512,24.993569 L11.0400688,25 L2.03488372,25 C0.911048474,25 0,24.0889515 0,22.9651163 C0,21.8974728 0.822221248,21.0218694 1.86799162,20.9369781 L2.03488372,20.9302326 L11.0400688,20.9302326 L11.8048254,20.925519 L12.499963,20.9109733 L13.1314082,20.8859876 C14.7356068,20.8048993 15.7236355,20.6059705 16.6012242,20.2373469 L16.9261308,20.0910574 C17.0333659,20.0395752 17.1398631,19.9853402 17.2466102,19.9282513 C18.4079287,19.3071714 19.3071714,18.4079287 19.9282513,17.2466102 C19.9853402,17.1398631 20.0395752,17.0333659 20.0910574,16.9261308 L20.2373469,16.6012242 C20.5829315,15.7784848 20.7793703,14.8586789 20.8693899,13.4250982 L20.8998234,12.8232768 C20.9039834,12.7180771 20.9076958,12.610347 20.9109733,12.499963 L20.925519,11.8048254 L20.9302326,11.0400688 L20.9302326,2.03488372 C20.9302326,0.911048474 21.841281,0 22.9651163,0 Z';

@Component
export struct ToggleHome {
  @State private isVisible: boolean = false;
  private isHover?: boolean = true;
  private imageWidthPx: number = 0;
  private isMouse = false;
  private springCurve: Curves.ICurve = Curves.springCurve(1, 1, 410, 38);
  @State iconScale: number = 1;
  private commandPath: string = WGR_SVG;
  private imageRes: Resource = $r('app.media.toggle_wgr');

  aboutToAppear(): void {
    log.showInfo('ToggleHome, aboutToAppear');
    this.imageWidthPx = vp2px(StyleConstants.IMAGE_SIZE);
    log.showInfo(`ToggleHome, aboutToAppear  + this.imageWidthPx: ${this.imageWidthPx}`);
    this.springCurve = Curves.springCurve(1, 1, 410, 38);
    this.initResource();
  }

  private initResource():void {
    if (DeviceHelper.isHYM() || (DeviceHelper.isPC() && DeviceHelper.isEmulator())) {
      this.commandPath = KLV_SVG;
      this.imageRes = $r('app.media.toggle_klv');
    }
  }

  aboutToDisappear() {
    log.showInfo('ToggleHome, aboutToDisappear');
  }

  build() {
    Row() {
      Stack() {
        Shape() {
          Path()
            .commands(this.commandPath)
            .fill('rgba(0,0,0,0)')
            .antiAlias(true)
            .strokeOpacity(0.05)
            .stroke('#000000')
            .strokeWidth(1)
            .width(StyleConstants.IMAGE_SIZE)
            .height(StyleConstants.IMAGE_SIZE)
            .backgroundBlurStyle(BlurStyle.Thick, { policy: 1 })
        }
        .clip(new Path({
          width: StyleConstants.IMAGE_SIZE,
          height: StyleConstants.IMAGE_SIZE,
          commands: this.commandPath
        }))
        .antiAlias(true)
        .width(StyleConstants.IMAGE_SIZE)
        .height(StyleConstants.IMAGE_SIZE)
        .position({
          x: StyleConstants.WINDOW_WIDTH_VP - StyleConstants.IMAGE_SIZE - StyleConstants.TOGGLE_MARGIN,
          y: StyleConstants.WINDOW_HEIGHT_VP - StyleConstants.IMAGE_SIZE - StyleConstants.TOGGLE_MARGIN
        })

        Image(this.imageRes).draggable(false)
          .width(StyleConstants.IMAGE_SIZE)
          .height(StyleConstants.IMAGE_SIZE)
          .position({
            x: StyleConstants.WINDOW_WIDTH_VP - StyleConstants.IMAGE_SIZE - StyleConstants.TOGGLE_MARGIN,
            y: StyleConstants.WINDOW_HEIGHT_VP - StyleConstants.IMAGE_SIZE - StyleConstants.TOGGLE_MARGIN
          })
          .interpolation(ImageInterpolation.High)
      }
      .key(HOME_KEY)
      .visibility(this.isVisible ? Visibility.Visible : Visibility.Hidden)
      .width(StyleConstants.WINDOW_WIDTH_VP)
      .height(StyleConstants.WINDOW_HEIGHT_VP)
      .scale({
        x: this.iconScale,
        y: this.iconScale,
        centerX: this.imageWidthPx * 2 / 3,
        centerY: this.imageWidthPx * 2 / 3
      })
      .animation({
        curve: this.springCurve
      })
      .onClick((event?: ClickEvent) => {
        this.doHotAreaClickEvent(event);
      })
      .onMouse((event?: MouseEvent) => {
        if (!sSCBOobeManager.isEnable()) {
          if (event?.button == MouseButton.Left && event?.action == MouseAction.Press) {
            this.isMouse = true;
            this.iconScale = 0.9;
          } else {
            this.isMouse = false;
            this.iconScale = 1;
          }
          this.doMouseEvent(event);
        }
      })
    }
    .width(StyleConstants.WINDOW_WIDTH_VP)
    .height(StyleConstants.WINDOW_HEIGHT_VP)
    .onHover((isHover?: boolean) => {
      log.showInfo(`onHover  isHover: ${isHover}`);
      this.isHover = isHover;
      if (!this.isHover) {
         this.isVisible = false;
      }
    })
    .onMouse((event?: MouseEvent) => {
      if (!sSCBOobeManager.isEnable()) {
        this.doMouseEvent(event);
      }
    })
    .width(StyleConstants.PERCENTAGE_100)
    .height(StyleConstants.PERCENTAGE_100)
  }

  private doMouseEvent(event?: MouseEvent) {
    log.showInfo('doMouseEvent');
    log.showInfo(`onMouse:Button = event.button: ${event?.button} + Action = (event.action: ${event?.action} + localXY=(event.x: ${event?.x} + event.y: ${event?.y}))`);
    log.showInfo(`screenXY=(event.screenX: ${event?.screenX} + event.screenY: ${event?.screenY}), isHover: ${this.isHover}`);
    if (this.isHover) {
      log.showInfo(`doMouseEvent this.isVisible: ${this.isVisible}`);
      this.isVisible = true;
      return
    }
    this.isVisible = false;
  }

  private doHotAreaClickEvent(event?: ClickEvent) {
    log.showInfo(`doHotAreaClickEvent : event.x: ${event?.x} + event.y: ${event?.y}`);
    toggleHomePresenter.doPresent(this.isMouse);
    this.isMouse = false;
  }
}