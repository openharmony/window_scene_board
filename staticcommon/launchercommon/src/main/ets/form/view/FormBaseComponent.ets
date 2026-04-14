/**
 * Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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

import type ctx from '@ohos.app.ability.common';
import { CheckEmptyUtils, LogDomain, LogHelper, StartType } from '@ohos/basicutils';
import { GlobalContext, ErrorCardResultType, FormLocationType } from '@ohos/frameworkwrapper';
import {
  SCBTransitionController,
  SCBTransitionManager,
  ResUtils,
  ScenePanelState,
  SCBOobeManager,
  AppData,
} from '@ohos/windowscene';
import {
  CardItemInfo,
  FormCommonUtil,
  FormLocation,
  editModeManager,
  EditModeState,
  StyleConstants,
  CommonConstants,
} from '../../TsIndex';
import { FormComponentConfig, FormComponentDisplayStyle } from '../model/FormComponentConfig';
import { FormComponentEvent } from '../viewmodel/FormComponentEvent';
import { FormComponentVm } from '../viewmodel/FormComponentVm';
import { OverflowConstants } from '@ohos/commonconstants';
import { CardNodeController } from '../../buildernode/CardNodeController';
import {
  CardNodeControllerManager,
  FormBasicParams,
  FormComponentBasicData,
  FormComponentBasicEvent
} from '../../manager/CardNodeControllerManager';
import { OverflowFormInfoUtil } from '../../utils/OverflowFormInfoUtil';
import { FormDFXUtil } from '../../utils/FormDFXUtil';
import { FormHostService } from '../manager/FormHostService';

const TAG = 'FormBaseComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const MAX_REBUILD_TIMES: number = 3;
const MAX_CLICK_TIMES: number = 5;
const REBUILD_GAP_TIME: number = 1000;
const CARDID_NOT_EXIST_ERRORCODE: number = 16501001;

@Component
export struct FormBaseComponent {
  private mFormItem: CardItemInfo = new CardItemInfo();
  @Prop mFormItemWidth: number = 0;
  @Prop mFormItemHeight: number = 0;
  private skeletonEnable?: boolean;
  @Prop @Watch('updateFormDisplay') mFormSizeChange: boolean = false;
  // FormComponent组件的.id
  private mFormComponentId: string = '';
  private formId: string = '';
  private desktopContext: ctx.ServiceExtensionContext = GlobalContext.getContext();
  private mFormComponentStyle: FormComponentDisplayStyle = new FormComponentDisplayStyle();
  private mFormComponentConfig: FormComponentConfig = FormComponentConfig.getInstance();
  private shadowStyle: ShadowOptions = {
    radius: StyleConstants.FORM_SHADOW_RADIUS,
    color: StyleConstants.FORM_SHADOW_COLOR,
    offsetY: StyleConstants.FORM_SHADOW_OFFSETY
  };
  private mFormComponentEvent?: FormComponentEvent;
  private transitionController?: SCBTransitionController;

  getFormId?: (id: string) => void;
  clickForm?: () => void;

  private isOuterDesktop: boolean = false;
  @Prop mFormBorderRadius: number = ResUtils.getNumber($r('app.float.form_corner_radius'));
  @Prop mDropAnimateTranslateY: number = 0;
  @Consume isInDrag: boolean;
  @Link mFormComponentVm: FormComponentVm;
  @StorageProp('wallpaperChangeFlag') @Watch('updateFormColor') wallpaperValue: boolean = true;
  @State editModeState: EditModeState = editModeManager.getEditModeState();
  @State mUIExtensionWant: Want = {};
  @State enableBlurBackground: boolean = false;
  @State blurBackgroundOpacity: number = 1;
  @StorageLink('formZoomId') formZoomId: string = '-1';
  @StorageLink('showFormZoomSnapshot') showFormZoomSnapshot: boolean = false;
  private lastRebuildTime: number = Date.now();
  @State rebuildTimes: number = 0;
  @State isErrorCard: boolean = false;
  private cardController: CardNodeController | null = null;

  private updateFormColor(): void {
    if (!this.mFormItem.isTransparent) {
      return;
    }
    FormCommonUtil.updateFormColor(this.formId as string, this.isOuterDesktop);
  }

  private initEnableBlurBackground(): void {
    this.enableBlurBackground = FormCommonUtil.getEnableBlurBackground(this.mFormItem);
    log.showInfo(`init enableBlurBackground: ${this.enableBlurBackground}`);
    // 带有模糊背板的卡片增加透明度渐变的过渡动画，避免跳变问题
    if (this.enableBlurBackground) {
      setTimeout(() => {
        animateTo({
          duration: 1000,
        }, () => {
          this.blurBackgroundOpacity = 0.85;
        })
      }, 1000);
    }
  }

  private onErrorHandling(errorMsg: string, isOuter: boolean, isRecoverable: boolean): void {
    log.showError(`FormComponent error msg: ${errorMsg}, cardId is: ${this.mFormItem.cardId}, retryTimes: ${this.rebuildTimes}, isOuter: ${isOuter}, isRecoverable: ${isRecoverable}`);
    if (SCBOobeManager.isOobeActivated() || isRecoverable) {
      log.showError(`inoobe or isRecoverable, cardId: ${this.mFormItem.cardId}, retryTimes: ${this.rebuildTimes}`);
      if (this.rebuildTimes < MAX_REBUILD_TIMES) {
        log.showError(`form onerror try to rebuild, retryTimes: ${this.rebuildTimes}`);
        this.mFormItem.cardId = '0';
        this.cardController = new CardNodeController(new FormBasicParams(
          this.getFormComponentBasicData(), this.getFormComponentBasicEvent()), TAG);
        this.rebuildTimes++;
      } else {
        this.isErrorCard = true;
      }
      return;
    }
    this.isErrorCard = true;
    this.mFormComponentEvent?.onErrorEvent(this.mFormItem, isOuter, ErrorCardResultType.ONERROR, errorMsg);
  }

  aboutToAppear(): void {
    log.showWarn('aboutToAppear, formItemWidth: %{public}d, formItemHeight: %{public}d, isTransparent: %{public}s,' +
      'formConfigAbility: %{public}s, extend2: %{public}d formId: %{public}s', this.mFormItemWidth, this.mFormItemHeight,
      this.mFormItem.isTransparent, this.mFormItem.formConfigAbility, this.mFormItem.extend2, this.mFormItem.cardId);
    this.formId = this.mFormItem.cardId;
    this.mFormComponentId = FormCommonUtil.getFormComponentId(this.mFormItem);
    this.updateFormDisplay();
    this.cardController = new CardNodeController(new FormBasicParams(
        this.getFormComponentBasicData(), this.getFormComponentBasicEvent()), TAG);
    this.initEnableBlurBackground();
    let appData: AppData = {
      bundleName: this.mFormItem.bundleName as string,
      abilityName: this.mFormItem.abilityName as string,
      appIconId: this.mFormComponentId as string,
      iconRadius: this.mFormBorderRadius,
      appIconNumber: Number(this.mFormItem.cardId),
      cardId: this.mFormItem.cardId,
      startAppType: StartType.CARD
    };
    this.transitionController = {
      appData: appData,
      cardDimension: this.mFormItem.cardDimension,
      onActive: (): void => this.mFormComponentEvent?.onActive(this.mFormItem.bundleName),
      onInactive: (): void => this.mFormComponentEvent?.onInactive(this.mFormItem.bundleName)
    };
    SCBTransitionManager.getInstance().registerTransitionController(this.transitionController);
    // 堆叠展开态拖拽或者删除剩一张卡片回落
    if (AppStorage.get('formStackEditShow') as boolean &&
      AppStorage.get('cardDropByFromStackExpandClose') as string === this.mFormItem.cardId) {
      this.mFormComponentEvent?.initFsExpandStatusEventhub(this.mFormItem.cardId);
    }
    this.mFormComponentEvent?.initFormInfo(this.mFormItem);
    this.mFormComponentEvent?.init();
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear, bundleName: ${this.mFormItem.bundleName} formId: ${this.mFormItem.cardId}`);
    if (this.transitionController) {
      SCBTransitionManager.getInstance().unRegisterTransitionController(this.transitionController);
    }
    this.mFormComponentEvent?.destroy();
    this.cardController = null;
  }

  private updateFormVisibility(): Visibility {
    log.showWarn(`formVisible: ${this.mFormComponentVm.mFormVisible}`);
    return this.mFormComponentVm.mFormVisible &&
      (this.formZoomId !== this.mFormComponentId || !this.showFormZoomSnapshot) ?
      Visibility.Visible : Visibility.Hidden;
  }

  private updateFormDisplay(): void {
    log.showWarn('updateFormDisplay formSizeChange');
    this.mFormComponentStyle = this.mFormComponentConfig.getFormComponentDisplayStyle(this.mFormItem.cardDimension,
      { width: this.mFormItemWidth, height: this.mFormItemHeight });
  }

  private updateFormSize(change: boolean): Size | undefined {
    log.showInfo(`updateFormSize width: ${this.mFormComponentStyle?.formLayoutSize?.width},` +
      ` height: ${this.mFormComponentStyle?.formLayoutSize?.height}`, );
    return this.mFormComponentStyle?.formLayoutSize;
  }

  private updateFormScale(change: boolean): ScaleOptions {
    log.showInfo(`updateFormScale ${this.mFormComponentStyle?.displayRate}`);
    return { x: this.mFormComponentStyle?.displayRate, y: this.mFormComponentStyle?.displayRate };
  }

  @Styles
  CommonStyles() {
    .size({ width: this.mFormItemWidth as number, height: this.mFormItemHeight as number })
    .transition(TransitionEffect.IDENTITY)
    .hoverEffect(HoverEffect.None)
    .alignRules({
      middle: { anchor: '__container__', align: HorizontalAlign.Center },
      top: { anchor: '__container__', align: VerticalAlign.Top },
    })
    .translate({ y: this.mDropAnimateTranslateY })
    .visibility(this.updateFormVisibility())
    // 编辑模式屏蔽卡片点击事件
    .enabled(!this.editModeState.isInEditMode())
  }

  @Styles
  layoutStyles() {
    .size({ width: this.mFormItemWidth as number, height: this.mFormItemHeight as number })
    .alignRules({
      middle: { anchor: '__container__', align: HorizontalAlign.Center },
      top: { anchor: '__container__', align: VerticalAlign.Top },
    })
  }

  @Builder
  OuterFormComponent() {
    Stack() {
      NodeContainer(this.cardController)
        .size(this.updateFormSize(this.mFormSizeChange))
        .scale(this.updateFormScale(this.mFormSizeChange))
        .alignRules({
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
          top: { anchor: '__container__', align: VerticalAlign.Top },
        })
        .onClick(event => {
          log.showWarn(`cardId: ${this.mFormItem.cardId} isErrorCard: ${this.isErrorCard}.`);
          if (this.isErrorCard && ((Date.now() - this.lastRebuildTime) > REBUILD_GAP_TIME) &&
            this.rebuildTimes < MAX_CLICK_TIMES) {
            log.showWarn(`errorCard rebuild, cardId: ${this.mFormItem.cardId}, rebuildTimes: ${this.rebuildTimes}`);
            this.rebuildTimes++;
            this.mFormItem.cardId = '0';
            this.cardController = new CardNodeController(new FormBasicParams(
              this.getFormComponentBasicData(), this.getFormComponentBasicEvent()), TAG);
            this.lastRebuildTime = Date.now();
          }
        })
    }
    .id(this.mFormComponentId)
    .shadow(this.mFormComponentEvent?.isFormSupportShadow() ? this.shadowStyle : null)
    .CommonStyles()
    .clip(true)
  }

  isSceneAnimationForm() {
    return this.mFormItem.gameCardInfo?.extensionType === OverflowConstants.ANIMATION_TYPE;
  }

  private getFormComponentBasicData(): FormComponentBasicData {
    return new FormComponentBasicData(
      this.mFormItem.cardId,
      this.mFormItem.cardName,
      this.mFormItem.bundleName,
      this.mFormItem.abilityName,
      this.mFormItem.moduleName,
      this.mFormItem.cardDimension,
      FormCommonUtil.getCommonWant({
        extend1: this.mFormItem?.extend1,
        isTransparent: this.mFormItem.isTransparent,
        formLocation: FormLocation.DESKTOP,
        cardName: this.mFormItem.cardName,
        bundleName: this.mFormItem.bundleName,
        skeletonEnable: this.skeletonEnable,
        liveFormWidth: this.isSceneAnimationForm() ? this.mFormItemWidth : undefined,
        liveFormHeight: this.isSceneAnimationForm() ? this.mFormItemHeight : undefined,
        isOuterDesktop: this.isOuterDesktop,
        targetFormData: this.mFormItem.targetFormData,
      }),
      this.mFormBorderRadius,
      this.isOuterDesktop ? this.mFormComponentStyle?.formLayoutSize?.width as number : this.mFormItemWidth,
      this.isOuterDesktop ? this.mFormComponentStyle?.formLayoutSize?.height as number : this.mFormItemHeight,
      this.isOuterDesktop ? `Outer_${this.mFormComponentId}` : undefined,
      undefined,
      OverflowFormInfoUtil.isGameCard(this.mFormItem),
      false,
    );
  }

  private getFormComponentBasicEvent(): FormComponentBasicEvent {
    // 基本事件
    return {
      // 组件内部异常回调
      onError: (error) => {
        let errorMsg: string = `errorcode: ${error?.errcode}, errorMsg: ${error?.msg}`;
        let isRecoverable: boolean = false;
        if (error?.errcode == CARDID_NOT_EXIST_ERRORCODE) {
          isRecoverable = true;
        }
        this.onErrorHandling(errorMsg, this.isOuterDesktop, isRecoverable);
      },
      // 唯一性标识更新，会触发UI组件上下树
      onAcquired: (form: FormCallbackInfo) => {
        FormDFXUtil.reportBuildCard(this.mFormItem, form.idString, FormLocationType.DESKTOP);
        if (CheckEmptyUtils.isEmpty(form)) {
          log.showError('form item onAcquired formCallbackInfo invalid!');
          return;
        }
        log.showInfo(`FormComponent card id is: ${form.idString}`);
        this.isErrorCard = false;
        this.rebuildTimes = 0;
        this.formId = String(form.idString);
        if (this.getFormId) {
          this.getFormId(this.formId);
        }
        FormHostService.getInstance().formHostNotifyCardVisibility(this.mFormItem.cardId,
          this.mFormItem.page, this.isOuterDesktop);
      },
      // 卡片点击启动， 记录打点信息
      onRouter: () => {
        log.showWarn(`FormComponent onRouter, cardId: ${this.mFormItem.cardId}.`);
        this.clickForm?.();
      },
      // 卡片uninstall回调
      onUninstall: (form: FormCallbackInfo) => {
        log.showInfo(`uninstall form success, formId: ${form?.idString} FormItemCardId: ${this.mFormItem.cardId}`);
        this.mFormComponentEvent?.onErrorEvent(this.mFormItem, this.isOuterDesktop, ErrorCardResultType.ONUNINSTALL);
      },
      onTouch: () => {},
      // onLoad事件
      onLoad: () => {}
    }
  }

  @Builder
  defaultComponent() {
    NodeContainer(this.cardController)
      .layoutStyles()
      .shadow(this.mFormComponentEvent?.isFormSupportShadow() ? this.shadowStyle : null)
      .onClick(event => {
        log.showWarn(`cardId: ${this.mFormItem.cardId} isErrorCard: ${this.isErrorCard}.`);
        if (this.isErrorCard && ((Date.now() - this.lastRebuildTime) > REBUILD_GAP_TIME) &&
          this.rebuildTimes < MAX_CLICK_TIMES) {
          log.showWarn(`errorCard rebuild, cardId: ${this.mFormItem.cardId}, rebuildTimes: ${this.rebuildTimes}`);
          this.rebuildTimes++;
          this.mFormItem.cardId = '0';
          this.cardController = new CardNodeController(new FormBasicParams(
            this.getFormComponentBasicData(), this.getFormComponentBasicEvent()), TAG);
          this.lastRebuildTime = Date.now();
        }
      })
      .accessibilityLevel('no')
  }

  @Builder
  FormRetryBuilder() {
    // 控制组件重建
    if (this.rebuildTimes % 2 === 0) {
      this.CommonFormComponent();
    } else {
      this.CommonFormComponent();
    }
  }

  @Builder
  CommonFormComponent() {
    if (this.isOuterDesktop) {
      this.OuterFormComponent();
    } else {
      this.defaultComponent();
    }
  }

  @Builder
  useEffectComponent(isTransparent: boolean) {
    Stack() {
      if (this.isErrorCard || (this.enableBlurBackground && !isTransparent)) {
        // 模糊背板
        Column()
          .layoutStyles()
          .useEffect(true)
        // 适配深浅色模式的颜色背板
        Column()
          .layoutStyles()
          .backgroundColor(this.isErrorCard ? Color.Transparent : $r(`app.color.app_form_back_board`))
          .opacity(this.blurBackgroundOpacity)
      }
      // 卡片组件
      this.FormRetryBuilder()
    }
    .id(this.mFormComponentId)
    .CommonStyles()
  }

  build() {
    this.useEffectComponent(this.mFormItem.isTransparent)
  }
}