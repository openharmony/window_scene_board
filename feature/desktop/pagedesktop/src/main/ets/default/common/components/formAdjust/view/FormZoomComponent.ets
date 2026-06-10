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

import image from '@ohos.multimedia.image';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CardItemInfo, CommonConstants, FormCommonUtil, FormLocation } from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  FormZoomViewController,
  FormZoomViewManager,
  FormZoomViewParam,
} from '@ohos/launchercommon/src/main/ets/manager/FormZoomViewManager';
import {
  ZoomHotArea,
} from '../common/FormZoomCommonType';
import { FormZoomUtil } from '../common/FormZoomUtil';
import { FormZoomVm, ZoomBarVisible } from '../viewModel/FormZoomVm';
import { FormZoomEvent } from '../viewModel/FormZoomEvent';
import { FormZoomHotAreaComponent } from './FormZoomHotAreaComponent';
import { FormZoomManager } from '../common/FormZoomManager';
import { FormViewModel } from '@ohos/form';
import { formZoomController } from '../viewModel/FormZoomController';

const TAG = 'FormZoomComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const BORDER_WIDTH: number = 1.5;
const OPACITY_DEFAULT: number = 0.2;
const HALF: number = 0.5;
const TRANSITION_DELAY: number = 50;

interface FormZoomSupportInfo {
  cardName: string;
  cardDimension: number;
}

/**
 * 调整卡片大小的组件
 */
@Component
export struct FormZoomComponent {
  private mFormZoomViewManager: FormZoomViewManager = FormZoomViewManager.getInstance();
  @State mFormZoomShow: boolean = false;
  @State mFormZoomVisible: Visibility = Visibility.Visible;
  @State snapshot?: image.PixelMap = undefined;
  @State switch: boolean = true;
  @StorageLink('showFormZoomSnapshot') @Watch('updateSnapshot') showFormZoomSnapshot: boolean = false;
  @StorageProp('screenWidth') screenWidth: number = 0;
  @StorageProp('screenHeight') screenHeight: number = 0;
  @State mFormZoomVm: FormZoomVm = new FormZoomVm();
  @State translateX: number = 0;
  @State translateY: number = 0;
  @State mFormItemWidth: number = 0;
  @State mFormItemHeight: number = 0;
  @State mFormBorderRadius: number = 0;
  @State isNeedTransition: boolean = false;
  @State barVisible: ZoomBarVisible = new ZoomBarVisible(true, true, true, true);
  @State cardInfos: CardItemInfo[] = [];
  @State @Watch('updateTransition') inDrag: boolean = false;
  private switchCardSnapshot = (key: string) => {
    this.snapshot = FormZoomManager.getInstance().getCardSnapshot(key) ||
    FormZoomManager.getInstance().getFormZoomSnapshot();
    this.switch = !this.switch;
  }
  @Provide public mFormZoomEvent: FormZoomEvent =
    new FormZoomEvent(this.mFormZoomVm, this.mFormItemWidth, this.mFormItemHeight, this.switchCardSnapshot);

  private mViewController: FormZoomViewController = {
    openView: (param: FormZoomViewParam) => {
      this.openView(param);
    },
    closeView: () => {
      this.closeView();
    },
    showView: () => {
      this.showView();
    },
    hideView: () => {
      this.hideView();
    },
    getViewState: () => {
      return this.mFormZoomShow;
    }
  }

  private updateTransition(): void {
    // 普通卡片拖拽调整大小过程中截图切换需要过渡动效
    if (this.inDrag) {
      // 拖拽状态变化后延时修改动效，避免按压线框时出现截图渐显动效
      let timer: number = setTimeout(() => {
        this.isNeedTransition = true;
        clearTimeout(timer);
      }, TRANSITION_DELAY);
    } else {
      this.isNeedTransition = false;
    }
  }

  private updateSnapshot(): void {
    log.showInfo(`showFormZoomSnapshot changed: ${this.showFormZoomSnapshot}`);
    if (this.showFormZoomSnapshot) {
      this.snapshot = FormZoomManager.getInstance().getFormZoomSnapshot();
    }
  }

  private openView(param: FormZoomViewParam): void {
    let currentFormZoomId: string | undefined = AppStorage.get('formZoomId');
    log.showWarn(`currentFormZoomId: ${currentFormZoomId}, param.formComponentId: ${param.formComponentId}`);
    AppStorage.setOrCreate('formZoomId', param.formComponentId);
    this.mFormItemWidth = param.formItemWidth;
    this.mFormItemHeight = param.formItemHeight;
    this.mFormBorderRadius = param.formBorderRadius;
    let supportInfos: FormZoomSupportInfo[];
    supportInfos = FormCommonUtil.getFormZoomSupportInfos(param.formInfo);
    let cardInfos: CardItemInfo[] = supportInfos.map((supportInfo) => {
      let cardInfo: CardItemInfo = new CardItemInfo();
      cardInfo.cardName = supportInfo.cardName;
      cardInfo.cardDimension = supportInfo.cardDimension;
      cardInfo.bundleName = param.formInfo.bundleName;
      cardInfo.abilityName = param.formInfo.abilityName;
      cardInfo.moduleName = param.formInfo.moduleName;
      return cardInfo;
    })
    this.cardInfos = [];
    log.showInfo(`form zoom view param, width: ${param.formItemWidth}, height: ${param.formItemHeight}, bordarRadius: ${param.formBorderRadius}`);
    this.translateX = param.rectInfo.left + 0.5 * (param.rectInfo.width || 0) - 0.5 * this.screenWidth;
    this.translateY = param.rectInfo.top + 0.5 * (param.rectInfo.height || 0) - 0.5 * this.screenHeight;
    this.mFormZoomEvent =
      new FormZoomEvent(this.mFormZoomVm, this.mFormItemWidth, this.mFormItemHeight, this.switchCardSnapshot);
    try {
      this.mFormZoomEvent.initCardInfo(param.formInfo, cardInfos);
      this.mFormZoomEvent.setFormZoomSize({ width: this.mFormItemWidth, height: this.mFormItemHeight });
      this.inDrag = false;
      this.mFormZoomShow = true;
    } catch (err) {
      log.showError(`open form zoom view failed: ${err?.message}`);
    }
  }

  private closeView(): void {
    if (!this.mFormZoomShow) {
      return;
    }
    FormZoomManager.getInstance().releaseSnapshot();
    FormZoomManager.getInstance().clearTempCard();
    this.mFormZoomShow = false;
  }

  private showView(): void {
    this.mFormZoomVisible = Visibility.Visible;
  }

  private hideView(): void {
    this.mFormZoomVisible = Visibility.Hidden;
  }

  @Builder
  DragBarBuilder() {
    // 上
    DragBarComponent()
      .offset({
        x: 0,
        y: -(this.mFormZoomVm.height - BORDER_WIDTH) * HALF
      })
      .visibility(this.barVisible?.top ? Visibility.Visible : Visibility.Hidden)
    // 下
    DragBarComponent()
      .offset({
        x: 0,
        y: (this.mFormZoomVm.height - BORDER_WIDTH) * HALF
      })
      .visibility(this.barVisible?.bottom ? Visibility.Visible : Visibility.Hidden)
    // 左
    DragBarComponent()
      .offset({
        x: -(this.mFormZoomVm.width - BORDER_WIDTH) * HALF,
        y: 0
      })
      .visibility(this.barVisible?.left ? Visibility.Visible : Visibility.Hidden)
    // 右
    DragBarComponent()
      .offset({
        x: (this.mFormZoomVm.width - BORDER_WIDTH) * HALF,
        y: 0
      })
      .visibility(this.barVisible?.right ? Visibility.Visible : Visibility.Hidden)
  }

  aboutToAppear(): void {
    log.showInfo('FormZoomComponent about to appear');
    formZoomController.bindFormZoomComponent(this);
    this.mFormZoomViewManager.registerFormZoomViewController(this.mViewController);
  }

  aboutToDisappear(): void {
    log.showInfo('FormZoomComponent about to disappear');
    formZoomController.unbindFormZoomComponent();
    this.mFormZoomViewManager.unRegisterFormZoomViewController();
  }

  build() {
    if (this.mFormZoomShow) {
      Stack() {
        Stack() {
          // 卡片截图
          Stack() {
            if (this.showFormZoomSnapshot) {
              if (this.switch) {
                Image(this.snapshot)
                  .draggable(false)
                  .width('100%')
                  .height('100%')
                  .syncLoad(true)
                  .interpolation(ImageInterpolation.Medium)
                  .autoResize(false)
                  .borderRadius(this.mFormBorderRadius)
                  .objectFit(ImageFit.Fill)
                  .transition(this.isNeedTransition ? TransitionEffect.asymmetric(
                    TransitionEffect.OPACITY.animation({ duration: 250, curve: Curve.Friction }),
                    TransitionEffect.OPACITY.animation({ delay: 200, duration: 100, curve: Curve.Friction }),
                  ): TransitionEffect.IDENTITY)
              } else {
                Image(this.snapshot)
                  .draggable(false)
                  .width('100%')
                  .height('100%')
                  .syncLoad(true)
                  .interpolation(ImageInterpolation.Medium)
                  .autoResize(false)
                  .borderRadius(this.mFormBorderRadius)
                  .objectFit(ImageFit.Fill)
                  .transition(this.isNeedTransition ? TransitionEffect.asymmetric(
                    TransitionEffect.OPACITY.animation({ duration: 250, curve: Curve.Friction }),
                    TransitionEffect.OPACITY.animation({ delay: 200, duration: 100, curve: Curve.Friction }),
                  ): TransitionEffect.IDENTITY)
              }
            }
          }
          .width('100%')
          .height('100%')
          .borderRadius(this.mFormBorderRadius)
          .clip(true)
          // 拖拽线框
          Column() {
          }
          .width('100%')
          .height('100%')
          .borderRadius(this.mFormBorderRadius)
          .borderWidth(BORDER_WIDTH)
          .borderColor('#0A59F7')
          // 拖拽把手
          this.DragBarBuilder()
          // 拖拽热区
          ForEach(FormZoomUtil.HOT_AREA_LIST, (hotArea: ZoomHotArea) => {
            FormZoomHotAreaComponent({
              mHotArea: hotArea,
              barVisible: this.barVisible,
              inDrag: this.inDrag,
            })
          }, (item: ZoomHotArea) => item.position.toString())
        }
        .width(this.mFormZoomVm.width)
        .height(this.mFormZoomVm.height)
        .hitTestBehavior(HitTestMode.None)

        // 支持可调整大小的卡片
        ForEach(this.cardInfos, (item: CardItemInfo) => {
          FormComponent({
            id: '0',
            name: item.cardName,
            bundle: item.bundleName,
            ability: item.abilityName,
            module: item.moduleName,
            dimension: item.cardDimension,
            want: FormCommonUtil.getCommonWant({ extend1: item.extend1, formLocation: FormLocation.DESKTOP}),
            temporary: true
          })
            .id(`formZoom_${item.bundleName}_${item.cardName}_${item.cardDimension}`)
            .allowUpdate(true)
            .size({
              width: FormViewModel.getInstance().getFormStyleConfig().mFormWidth.get(String(item.cardDimension)),
              height: FormViewModel.getInstance().getFormStyleConfig().mFormHeight.get(String(item.cardDimension)),
            })
            .visibility(Visibility.Hidden)
            .onAcquired((form: FormCallbackInfo)=>{
              log.showInfo(`onAcquired form info : ${JSON.stringify(form)}`);
              FormZoomManager.getInstance().addTempCardId(form.idString);
              FormZoomManager.getInstance().setCardSnapshot(`formZoom_${item.bundleName}_${item.cardName}_${item.cardDimension}`);
            })
            .onError((err)=>{
              log.showError(`onError fail to add form, err: ${JSON.stringify(err)}`);
            })
            .onUninstall((form: FormCallbackInfo)=>{
              log.showInfo(`onUninstall form success : ${JSON.stringify(form)}`);
            })
            .onUpdate((form: FormCallbackInfo)=>{
              log.showInfo(`onUpdate callback : ${JSON.stringify(form)}`);
            })
        })
      }
      .width(this.mFormItemWidth)
      .height(this.mFormItemHeight)
      .hitTestBehavior(this.inDrag ? HitTestMode.Block : HitTestMode.Transparent)
      .alignContent(this.mFormZoomVm.alignContent)
      .alignRules({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        top: { anchor: '__container__', align: VerticalAlign.Top },
      })
      .translate({
        x: this.translateX,
        y: this.translateY
      })
      .visibility(this.mFormZoomVisible)
    }
  }
}

/**
 * 拖拽把手：边框中心圆点
 */
@Component
export struct DragBarComponent {
  build() {
    Stack() {
      Circle({ width: 16, height: 16 }).fill(0xFFFFFF).opacity(OPACITY_DEFAULT)
      Circle({ width: 16, height: 16 }).fill(0x0A59F7).opacity(OPACITY_DEFAULT)
      Circle({ width: 6, height: 6 }).fill(0x0A59F7)
    }
    .width(16)
    .height(16)
  }
}