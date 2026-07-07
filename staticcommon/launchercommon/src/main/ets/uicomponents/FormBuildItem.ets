/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { editModeManager, EditModeState, FormManager, PageDesktopModel } from '../TsIndex';
import { BundleConstants, CommonConstants, FormLocation } from '../constants/CommonConstants';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { FormCommonUtil } from '../utils/FormCommonUtil';
import { CommonConfigData, FormStackItemBuildParam } from '../formstack/FormStackItemBuildParam';
import { FormStackConfig } from '../formstack/FormStackConfig';
import { FormStackItemBuildInterface, FormStackItemViewType } from '../formstack/FormStackItemBuildInterface';
import { FormStackItemViewData } from '../formstack/FormStackItemViewData';
import { FormComponentConfig, FormComponentDisplayStyle } from '../form/model/FormComponentConfig';
import { AiSuggestionUtil } from '../aisuggestion/AiSuggestionUtil';
import { CardNodeController } from '../buildernode/CardNodeController';
import {
  CardNodeControllerManager,
  FormBasicParams,
  FormComponentBasicData,
  FormComponentBasicEvent
} from '../manager/CardNodeControllerManager';
import { FormStackItemEventCb } from '../formstack/FormStackItemEventCb';
import { FormHostService } from '../form/manager/FormHostService';
import { FormLayoutCacheManager } from '../cache/layout/FormLayoutCacheManager';

const TAG: string = 'FormBuildItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormBuildItem implements FormStackItemBuildInterface {
  public type: FormStackItemViewType = FormStackItemViewType.FORM_COMPONENT;

  public isTypeMatch(layoutInfo: GridLayoutItemInfo): boolean {
    return layoutInfo.typeId === CommonConstants.TYPE_CARD &&
      !AiSuggestionUtil.isVoiceAbilityForm(layoutInfo.bundleName, layoutInfo.abilityName);
  }

  public buildView(): WrappedBuilder<FormStackItemBuildParam[]> {
    return wrapBuilder(buildForm);
  }
}

@Component
struct BaseForm {
  // 有效性在外面已经保证，避免各种运行时判断
  public readonly mConfigData: CommonConfigData = {} as CommonConfigData;
  public readonly mEventCb: FormStackItemEventCb = {} as FormStackItemEventCb;
  private mFormComponentStyle: FormComponentDisplayStyle = new FormComponentDisplayStyle();
  private mFormComponentConfig: FormComponentConfig = FormComponentConfig.getInstance();
  @State mOuterWidth: number = 0;
  @State mOuterHeight: number = 0;
  @State mOuterScale: number = 1;
  @State mEditModeState: EditModeState = editModeManager.getEditModeState();
  @ObjectLink @Watch('updateFormDisplay') mViewData: FormStackItemViewData;
  @State enableBlurBackground: boolean = false;
  private cardController: CardNodeController | null = null;

  private initEnableBlurBackground(): void {
    this.enableBlurBackground = FormCommonUtil.getEnableBlurBackground(this.mConfigData.mLayout);
    log.showInfo(`init enableBlurBackground: ${this.enableBlurBackground}`);
  }

  private updateFormVisibility(): void {
    // 堆叠子卡的位置信息不可信，需要使用父卡的位置
    let formStackId: string = this.mEventCb.getFormStackId();
    let cardId: string = this.mConfigData.mLayout.cardId ?? '';
    let page: number | undefined = FormLayoutCacheManager.getInstance()
      .selectGridLayoutItemByFormstackId(formStackId, this.mConfigData.mIsOuterDesktop)?.page;
    if (CheckEmptyUtils.isEmpty(page) || CheckEmptyUtils.isEmpty(cardId)) {
      log.showError(`notify visibility failed, id: ${cardId}, stack: ${formStackId}, page: ${page}`);
      return;
    }

    FormHostService.getInstance().formHostNotifyCardVisibility(cardId, page, this.mConfigData.mIsOuterDesktop);
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear cardId: ${this.mConfigData.mLayout.cardId}.`);
    this.updateFormDisplay();
    this.initEnableBlurBackground();
    if (this.mConfigData) {
      this.cardController = new CardNodeController(new FormBasicParams(
        this.getFormComponentBasicData(), this.getFormComponentBasicEvent()), TAG);
    }
  }

  aboutToDisappear(): void {
    this.cardController = null;
    log.showInfo(`aboutToDisappear cardId: ${this.mConfigData.mLayout.cardId}.`);
  }

  @Styles
  CommonStyles() {
    .width(this.mViewData.mWidth)
    .height(this.mViewData.mHeight)
    .borderRadius(this.mViewData.mBorderRadius)
  }

  @Builder
  useEffectComponent() {
    Stack() {
      if (this.enableBlurBackground) {
        // 模糊背板
        Column()
          .CommonStyles()
          .useEffect(true)
        // 适配深浅色模式的颜色背板
        Column()
          .CommonStyles()
          .backgroundColor($r(`app.color.app_form_back_board`))
          .opacity(0.85)
      }
      // 卡片组件
      this.defaultComponent()
    }
    .id(this.mConfigData.mCompId)
    .CommonStyles()
    .rotate({ x: 1, angle: this.mViewData.mRotateAngle, centerX: '50%', centerY: '0%' })
    .enabled(this.mViewData.mClickable && !this.mEditModeState.isInEditMode())
    .hoverEffect(HoverEffect.None)
    .draggable(false)
  }

  private getFormComponentBasicData(): FormComponentBasicData {
    return new FormComponentBasicData(
      this.mConfigData.mLayout.cardId ?? '',
      this.mConfigData.mLayout.cardName ?? '',
      this.mConfigData.mLayout.bundleName,
      this.mConfigData.mLayout.abilityName,
      this.mConfigData.mLayout.moduleName ?? '',
      this.mConfigData.mLayout.cardDimension ?? 0,
      FormCommonUtil.getCommonWant({
        extend1: this.mConfigData.mLayout.extend1,
        formLocation: FormLocation.DESKTOP,
        disableGesture: true,
        isOuterDesktop: this.mConfigData.mIsOuterDesktop
      }),
      this.mConfigData.mIsOuterDesktop ?
        this.mViewData.mBorderRadius / (this.mOuterScale || 1) : this.mViewData.mBorderRadius,
      this.mConfigData.mIsOuterDesktop ? this.mOuterWidth : this.mViewData.mWidth,
      this.mConfigData.mIsOuterDesktop ? this.mOuterHeight : this.mViewData.mHeight,
      this.mConfigData.mIsOuterDesktop ?
        this.mConfigData.mCompId : undefined,
      HoverEffect.None
    );
  }

  private getFormComponentBasicEvent(): FormComponentBasicEvent {
    // 基本事件
    return {
      // 组件内部异常回调
      onError: (error) => {
        this.mEventCb.onError(error.errcode, error.msg);
      },
      // 唯一性标识更新，会触发UI组件上下树
      onAcquired: (form: FormCallbackInfo) => {
        if (CheckEmptyUtils.isEmpty(form)) {
          log.showError('formstack item onAcquired formCallbackInfo invalid!');
          return;
        }
        this.mEventCb.onUpdateId(String(form.idString));
        this.updateFormVisibility();
      },
      // 卡片点击启动， 记录打点信息
      onRouter: () => {
        this.mEventCb.onClickForm();
      },
      // 卡片uninstall回调
      onUninstall: (form: FormCallbackInfo) => {
        this.mEventCb.onUninstall(form);
      },
      onLoad: () => {
        log.showWarn(`formstack child item onLoad, componentId: ${this.mConfigData.mCompId}.`);
        this.mEventCb.onLoadForm(this.mConfigData.mLayout.cardId as string);
      },
      onTouch: (event) => {
        this.mEventCb.onTouch(event);
      }
    }
  }

  @Builder
  defaultComponent() {
    NodeContainer(this.cardController)
      .CommonStyles()
      .shadow(FormStackConfig.getInstance().isSupportShadow() && this.mViewData.mIsSupportShadow ?
        this.mConfigData.mShadowStyle : null)
  }

  build() {
    if (this.mConfigData.mIsOuterDesktop) {
      this.OuterFormComponent()
    } else {
      this.useEffectComponent()
    }
  }

  @Builder
  OuterFormComponent() {
    NodeContainer(this.cardController)
      .size({ width: this.mOuterWidth, height: this.mOuterHeight })
      .scale({ x: this.mOuterScale, y: this.mOuterScale })
      .margin({top: this.mOuterHeight - this.mViewData.mHeight})
      .borderRadius(this.mViewData.mBorderRadius / (this.mOuterScale || 1))
      .rotate({
        x: 1,
        angle: this.mViewData.mRotateAngle,
        centerX: '50%',
        centerY: '0%'
      })
      .enabled(this.mViewData.mClickable && !this.mEditModeState.isInEditMode())
  }

  private updateFormDisplay(): void {
    this.mFormComponentStyle = this.mFormComponentConfig.getFormComponentDisplayStyle(this.mConfigData.cardDimension,
      { width: this.mViewData.mWidth, height: this.mViewData.mHeight });
    this.mOuterWidth = this.mFormComponentStyle?.formLayoutSize?.width as number;
    this.mOuterHeight = this.mFormComponentStyle?.formLayoutSize?.height as number;
    this.mOuterScale = this.mFormComponentStyle?.displayRate ?? 1;
    FormComponentConfig.getInstance()?.setOuterFormStackExpandScale(this.mOuterScale);
    PageDesktopModel.getInstance()?.setOuterFormStackExitScale(this.mOuterScale);
  }
}

@Builder
function buildForm(param: FormStackItemBuildParam) {
  BaseForm({
    mConfigData: param.mConfigData,
    mEventCb: param.mEventCb,
    mViewData: param.mViewData,
  })
}