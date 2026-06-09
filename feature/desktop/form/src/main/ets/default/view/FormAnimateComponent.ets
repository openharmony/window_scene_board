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

import curves from '@ohos.curves';
import image from '@ohos.multimedia.image';
import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils';
import {
  GlobalContext,
  ResourceManager,
  ViewCallback
} from '@ohos/frameworkwrapper';
import {
  CommonConstants,
  FormCenterViewManager
} from '@ohos/launchercommon';
import { Size } from '@kit.ArkUI';
import { ImageUtil } from '../util/ImageUtil';

const TAG: string = 'FormAnimateComponent';
const DEFAULT_LAYOUT_PERCENTAGE: string = '100%';
const log: Logger = Logger.getLogHelper(LogDomain.FORM);
const DELAY_TIME: number = 100;
const BG_BORDER_RADIUS: number = 20;
const DELAY: number = 10;

/**
 * 卡片区域卡片动效展示
 */
const EVENTHUB_FORM_CENTER_CARD_ANIMATE_START: string = 'cardViewFormAnimateFormCenterStart';
const EVENTHUB_CARD_ANIMATE_CREATE_FORM_CENTER: string = 'cardViewFormAnimateCreateFormCenter';
const EVENTHUB_CARD_ANIMATE_INTERRUPT: string = 'cardViewFormAnimateInterrupt';
const EVENTHUB_CARD_ANIMATE_END: string = 'cardViewFormAnimateEnd';

export enum FormAnimateType {
  DROP,
  ENTER_FORM_MANAGER,
  ADD_CARD_TO_INTELLIGENT
}

export class FormAnimateViewData {
  public startIconOpacity: number = 1;
  public startIcon: image.PixelMap | undefined = undefined;
  public finalIconOpacity: number = 0;
  public finalIcon: image.PixelMap | undefined = undefined;
  public isCompanionShow: boolean = false;
  public positionX: number = 0;
  public positionY: number = 0;
  public animateWidth: number = 0;
  public animateHeight: number = 0;
  public scaleX: number = 1;
  public scaleY: number = 1;
  public translateX: number = 0;
  public translateY: number = 0;
  public animateOpacity: number = 1;
  public companionRadius: number = BG_BORDER_RADIUS;
  public backgroundOpacity: number = 0;
  public backBoardColor: Resource = $r('app.color.normal_form_background_color');
  public type: FormAnimateType = FormAnimateType.DROP;

  public reset() {
    log.showInfo(TAG, 'reset');
    this.startIconOpacity = 1;
    this.finalIconOpacity = 0;
    this.startIcon = undefined;
    this.finalIcon = undefined;
    this.isCompanionShow = false;
    this.positionX = 0;
    this.positionY = 0;
    this.animateWidth = 0;
    this.animateHeight = 0;
    this.scaleX = 1;
    this.scaleY = 1;
    this.translateX = 0;
    this.translateY = 0;
    this.animateOpacity = 1;
    this.companionRadius = BG_BORDER_RADIUS;
    this.type = FormAnimateType.DROP
    this.backgroundOpacity = 0;
    this.backBoardColor = $r('app.color.normal_form_background_color');
  }
}

// 卡片拖拽落位动效组件
@Component
export struct FormAnimateComponent {
  @State viewData: FormAnimateViewData = new FormAnimateViewData()
  @StorageLink('formDropId') @Watch('getDropFormIcon') formDropId: string = '';
  @StorageProp('lockReceived') @Watch('destroyCompanionComponent') lockReceived: number = 0;
  mViewStateChangeCallback?: ViewCallback;
  private cacheIcon: string = '';
  private isTransparent: boolean = false;

  private getDropFormIcon(): void {
    log.showInfo(TAG, `getDropFormIcon, formDropId = ${this.formDropId}, type: ${this.viewData.type}`);
    if (!this.viewData.isCompanionShow || this.viewData.type !== FormAnimateType.ADD_CARD_TO_INTELLIGENT ||
      CheckEmptyUtils.checkStrIsEmpty(this.formDropId)) {
      return;
    }
    this.updateFinalIcon(this.formDropId);
    animateTo({
      duration: 200,
      curve: Curve.Sharp,
    }, () => {
      this.viewData.startIconOpacity = 0;
      this.viewData.finalIconOpacity = 1;
    });
  }

  private updateFinalIcon(iconId: string) {
    ImageUtil.snapImage(iconId, (value: image.PixelMap) => {
      if (!value) {
        log.showInfo(TAG, 'snapImage value is null');
        return;
      }
      this.delayReleasePixmap(this.viewData.finalIcon, DELAY);
      this.viewData.finalIcon = value;
      log.showInfo(TAG, `updateIcon success, snapshotComponentId = ${iconId}`)
    });
    let timer = setInterval(() => {
      ImageUtil.snapImage(iconId, (value: image.PixelMap) => {
        if (!value) {
          log.showInfo(TAG, 'snapImage value is null');
          return;
        }
        this.delayReleasePixmap(this.viewData.finalIcon, DELAY);
        this.viewData.finalIcon = value;
        log.showInfo(TAG, `updateIcon success, snapshotComponentId = ${iconId}`)
      })
    }, DELAY_TIME)
    setTimeout(() => {
      clearInterval(timer)
    }, 500)
  }

  aboutToAppear(): void {
    // 展示动画
    GlobalContext.getContext().eventHub.on(EVENTHUB_CARD_ANIMATE_CREATE_FORM_CENTER,
      (position: Position, size: Size, radius: number, cacheIcon: string, type: FormAnimateType,
        isTransparent: boolean) => {
        log.showInfo(TAG, `EVENTHUB_CARD_ANIMATE_CREATE_FORM_CENTER, type = ${type}, cacheIcon = ${cacheIcon}`)
        this.createAnimateForm(position, size, radius, cacheIcon, type, isTransparent);
      });

    // 开始执行动画
    GlobalContext.getContext().eventHub.on(EVENTHUB_FORM_CENTER_CARD_ANIMATE_START,
      (position: Position, size: Size) => {
        log.showInfo(TAG, `EVENTHUB_FORM_CENTER_CARD_ANIMATE_START`)
        this.startAnimate(position, size)
      });

    // 打断执行动画
    GlobalContext.getContext().eventHub.on(EVENTHUB_CARD_ANIMATE_INTERRUPT,
      () => {
        this.stopAnimate();
      });
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, 'aboutToDisappear');
    GlobalContext.getContext().eventHub.off(EVENTHUB_CARD_ANIMATE_CREATE_FORM_CENTER);
    GlobalContext.getContext().eventHub.off(EVENTHUB_FORM_CENTER_CARD_ANIMATE_START);
    GlobalContext.getContext().eventHub.off(EVENTHUB_CARD_ANIMATE_INTERRUPT);
    GlobalContext.getContext().eventHub.off(CommonConstants.EVENTHUB_FORM_MANAGER_EXIT);
  }

  private stopAnimate(): void {
    log.showInfo(TAG, 'stopAnimate');
    if (!this.viewData.isCompanionShow) {
      return;
    }
    this.destroyCompanionComponent();
  }

  private createAnimateForm(position: Position, size: Size, radius: number, cacheIcon: string,
    type: FormAnimateType, isTransparent: boolean) {
    log.showInfo(TAG, `createAnimateForm, isCompanionShow = ${this.viewData.isCompanionShow}, type = ${type}`)
    const animateTypeSet: Set<FormAnimateType> = new Set([
      FormAnimateType.DROP,
      FormAnimateType.ENTER_FORM_MANAGER,
      FormAnimateType.ADD_CARD_TO_INTELLIGENT]);
    if (this.viewData.isCompanionShow || !animateTypeSet.has(type)) {
      this.destroyCompanionComponent();
      return;
    }
    this.cacheIcon = cacheIcon;
    this.viewData.type = type;
    this.viewData.companionRadius = radius;
    this.viewData.startIcon = ResourceManager.getInstance().getCachedCardSnapshot(cacheIcon);
    this.viewData.finalIcon = ResourceManager.getInstance().getCachedCardSnapshot(cacheIcon);
    this.viewData.positionX = Number(position.x);
    this.viewData.positionY = Number(position.y);
    this.viewData.animateWidth = size.width;
    this.viewData.animateHeight = size.height;
    this.isTransparent = isTransparent;
    this.viewData.isCompanionShow = true;
  }

  private startAnimate(position: Position, size: Size) {
    log.showInfo(TAG, `startAnimate, isCompanionShow = ${this.viewData.isCompanionShow}, type = ${this.viewData.type}`)
    if (!this.viewData.isCompanionShow || (this.viewData.type !== FormAnimateType.DROP &&
      this.viewData.type !== FormAnimateType.ENTER_FORM_MANAGER &&
      this.viewData.type !== FormAnimateType.ADD_CARD_TO_INTELLIGENT)) {
      this.destroyCompanionComponent();
      return;
    }
    if (this.viewData.type === FormAnimateType.ENTER_FORM_MANAGER) {
      this.doOpenFormCenterAnimate(position, size)
    } else if (this.viewData.type === FormAnimateType.ADD_CARD_TO_INTELLIGENT) {
      this.mViewStateChangeCallback?.onShow?.(TAG);
      this.doAddToIntelligentAnimate(position, size)
    }
  }

  private doOpenFormCenterAnimate(position: Position, size: Size) {
    GlobalContext.getContext().eventHub.on(CommonConstants.EVENTHUB_FORM_MANAGER_EXIT, () => {
        log.showInfo(TAG, `EVENTHUB_FORM_MANAGER_EXIT`)
        this.destroyCompanionComponent();
      });
    if (this.cacheIcon !== '') {
      this.viewData.startIcon = ResourceManager.getInstance().getCachedCardSnapshot(this.cacheIcon);
      this.viewData.finalIcon = ResourceManager.getInstance().getCachedCardSnapshot(this.cacheIcon);
    }
    animateTo({
      curve: curves.springMotion(0.468, 0.93),
    }, () => {
      this.viewData.positionX = Number(position.x);
      this.viewData.positionY = Number(position.y);
      this.viewData.animateWidth = size.width;
      this.viewData.animateHeight = size.height;
      if (this.isTransparent) {
        this.viewData.backgroundOpacity = 1;
        this.viewData.backBoardColor = $r('app.color.transparent_form_background_color');
      } else {
        this.viewData.backgroundOpacity = 0;
        this.viewData.backBoardColor = $r('app.color.normal_form_background_color');
      }
    });
    animateTo({
      duration: 250,
      curve: Curve.Sharp,
      onFinish: () => {
        animateTo({
          curve: curves.springMotion(0.468, 0.63),
          onFinish: () => {
            // 延时300毫秒关闭，等待卡片加载完成
            setTimeout(() => {
              this.destroyCompanionComponent();
            }, 300)
          }
        }, () => {
          this.viewData.scaleX = 1;
          this.viewData.scaleY = 1;
        })
      }
    }, () => {
      this.viewData.scaleX = 1.1;
      this.viewData.scaleY = 1.1;
    });
  }

  private doAddToIntelligentAnimate(position: Position, size: Size) {
    animateTo(
      {
        duration: 350,
        curve: curves.cubicBezier(0.57, 0.00, 0.71, 1.00),
        onFinish: () => {
          log.showInfo(TAG, 'first scale step end');
          animateTo(
            {
              delay: 50,
              curve: curves.springMotion(0.468, 0.63, 0),
              onFinish: () => {
                log.showInfo(TAG, 'scale step end');
                this.destroyCompanionComponent();
              }
            }, () => {
            this.viewData.scaleX = 1.0;
            this.viewData.scaleY = 1.0;
          })
        }
      }, () => {
      this.viewData.scaleX = 1.1;
      this.viewData.scaleY = 1.1;
    })

    animateToImmediately({
      curve: curves.springMotion(0.468, 0.82, 0),
      onFinish: () => {
        log.showInfo(TAG, 'addFormAnimation end');
      }
    }, () => {
      this.viewData.positionX = Number(position.x);
      this.viewData.positionY = Number(position.y);
      this.viewData.animateWidth = size.width;
      this.viewData.animateHeight = size.height;
    });
  }

  private destroyCompanionComponent(): void {
    log.showInfo(TAG, `destroyCompanionComponent in formCenter: ${this.viewData.type}`);
    if (this.viewData.type === FormAnimateType.ENTER_FORM_MANAGER) {
      AppStorage.setOrCreate<boolean>('enterFormManager', false);
      GlobalContext.getContext()?.eventHub.emit('enterFormManagerDone');
      FormCenterViewManager.getInstance().setIsInFormEnterAnimate(false);
      GlobalContext.getContext().eventHub.off(CommonConstants.EVENTHUB_FORM_MANAGER_EXIT);
    }
    GlobalContext.getContext()?.eventHub.emit(EVENTHUB_CARD_ANIMATE_END);
    this.cacheIcon = '';
    this.isTransparent = false;
    this.delayReleasePixmap(this.viewData.startIcon, 0);
    this.delayReleasePixmap(this.viewData.finalIcon, 0);
    this.viewData.reset();
    this.mViewStateChangeCallback?.onHide?.(TAG);
  }

  private delayReleasePixmap(pixmap: image.PixelMap | undefined, delay: number): void {
    if (!CheckEmptyUtils.isEmpty(pixmap)) {
      let releasePixmap: image.PixelMap = pixmap as image.PixelMap;
      setTimeout(() => { releasePixmap.release(); }, delay);
    }
  }

  @Styles
  normalStyles(): void {
    .size({ width: this.viewData.animateWidth, height: this.viewData.animateHeight })
    .scale({ x: this.viewData.scaleX, y: this.viewData.scaleY })
    .position({
      x: this.viewData.positionX,
      y: this.viewData.positionY,
    })
    .translate({
      x: this.viewData.translateX,
      y: this.viewData.translateY
    })
    .borderRadius(this.viewData.companionRadius)
  }

  build() {
    if (this.viewData.isCompanionShow) {
      Stack() {
        Column() {
        }
        .opacity(this.viewData.backgroundOpacity)
        .backgroundColor(this.viewData.backBoardColor)
        .normalStyles()

        if (this.viewData.startIcon) {
          Image(this.viewData.startIcon)
            .draggable(false)
            .objectFit(ImageFit.Cover)
            .opacity(this.viewData.startIconOpacity)
            .shadow({
              radius: $r('app.float.normal_form_manager_radius'),
              color: $r('app.color.normal_form_manager_shadow_color'),
              offsetY: $r('app.float.normal_form_manager_offset')
            })
            .clip(true)
            .syncLoad(true)
            .autoResize(false)
            .interpolation(ImageInterpolation.Medium)
            .normalStyles()
        }

        if (this.viewData.finalIcon) {
          Image(this.viewData.finalIcon)
            .draggable(false)
            .objectFit(ImageFit.Cover)
            .opacity(this.viewData.finalIconOpacity)
            .shadow({
              radius: $r('app.float.normal_form_manager_radius'),
              color: $r('app.color.normal_form_manager_shadow_color'),
              offsetY: $r('app.float.normal_form_manager_offset')
            })
            .clip(true)
            .syncLoad(true)
            .autoResize(false)
            .interpolation(ImageInterpolation.Medium)
            .normalStyles()
        }
      }
      .zIndex(1)
      .height(DEFAULT_LAYOUT_PERCENTAGE)
      .width(DEFAULT_LAYOUT_PERCENTAGE)
    }
  }
}