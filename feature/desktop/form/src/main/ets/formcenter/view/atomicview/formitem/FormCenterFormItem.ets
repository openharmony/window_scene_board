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

import { ImageModifier } from '@ohos.arkui.modifier';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CardItemInfo, FormCommonUtil, FormModel, ReceiveEventInfo, CommonConstants } from '@ohos/launchercommon';
import { NumberConstants } from '@ohos/commonconstants';
import { CardAddType, FormCenterViewManager } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { AccessibilityManager, localEventManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { FormInLineBorder } from './CommonForm';
import { FormItemBuilderInterface } from '../../../interfaces/FormItemBuilderInterface';
import { FormItemAnimaInterface, FormItemAnimData, FormItemData } from '../../../viewmodel/data/FormItemVm';
import { FormItemStyle as FormItemStyle } from '../../../viewstyles/FormItemStyle';
import { FormItemEventInterface } from '../../../interfaces/FormItemEventInterface';
import { FormDescriptionEventInterface } from '../../../interfaces/FormDescriptionEventInterface';
import { FormDescriptionVm } from '../../../viewmodel/data/FormDescriptionVm';
import { FormCenterViewModel } from '../../../viewmodel/FormCenterViewModel';
import FormConstants from '../../../../default/common/constants/FormConstants';

const TAG = 'FormCenterFormItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Component
export struct FormCenterFormItem {
  public mEvent?: FormItemEventInterface;
  public formItem: CardItemInfo = new CardItemInfo();
  public idIndex: number = 0;
  public formRate: number = 1;
  public cardId: string = '';
  public buildInterface?: FormItemBuilderInterface;
  public isFormClickableInAccess: boolean = true;
  public style: FormItemStyle = new FormItemStyle();
  public formItemUIConfig: FormItemData = new FormItemData();
  public formDescriptionEvent?: FormDescriptionEventInterface;
  private addFormViewTrackSource: CardAddType = CardAddType.OTHERS;

  @State formDescriptionVm: FormDescriptionVm = new FormDescriptionVm();
  @State mAnimateData: FormItemAnimaInterface = new FormItemAnimData();
  @State isContentVisible: boolean = true;
  @State enableBlurBackground: boolean = false;
  @State isValidForm: boolean = false;
  @StorageProp('currColorMode') currColorMode: number = 1;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  private readonly mLocalEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, param: number) => {
      if (event === FormConstants.FORM_MOTION_EVENT && this.mEvent?.getIsCurrentIndex?.(this.idIndex)) {
        this.mEvent?.doFadeInAnimation?.(true);
        this.formItemUIConfig.formOpacity = 0;
        animateTo({
          delay: param,
          duration: 250,
          curve: Curve.Sharp,
          onFinish: () => {
            this.mEvent?.doFadeInAnimation?.(false);
            this.formItemUIConfig.formOpacity = 1;
          }
        }, () => {
          this.mEvent?.doFadeInAnimation?.(false);
          this.formItemUIConfig.formOpacity = 1;
        })
      }
    }
  }

  aboutToAppear(): void {
    // 卡片来源
    this.addFormViewTrackSource = FormCenterViewManager.getInstance().getOpenAddFormViewSource();
    // 卡片描述信息
    this.formDescriptionEvent?.updateFormDescriptionVm(this.formDescriptionVm, this.formItem);
    this.initEvent();
    this.initEnableBlurBackground();
    localEventManager.registerEventListener(this.mLocalEventListener, [FormConstants.FORM_MOTION_EVENT]);
    log.showInfo('aboutToAppear');
  }

  aboutToDisappear(): void {
    log.showDebug(`aboutToDisappear, ${this.idIndex}`);
    this.mEvent?.onDisAppear();
    localEventManager.unregisterEventListener(this.mLocalEventListener);
  }

  private initEvent(): void {
    this.mEvent?.initAnimateData?.(this.mAnimateData, this.idIndex);
    this.mEvent?.initFormUIConfig(this.formItemUIConfig, this.formRate);
  }

  private initEnableBlurBackground(): void {
    this.enableBlurBackground = FormCommonUtil.getEnableBlurBackground(this.formItem);
  }

  private getAccessibilityDescription(): string {
    if (this.isAccessibilityMode) {
      // 应用内拉起，无可用操作
      if (this.addFormViewTrackSource === CardAddType.ATOMIC_SERVICE ||
        this.addFormViewTrackSource === CardAddType.APP && !FormCenterViewModel.getInstance().isScreenLock) {
        return ',';
      }

      // 卡片中心，非分栏模式，可点击跳转卡片管理
      if (this.isFormClickableInAccess && !FormModel.getInstance().isSupportFormCenterSplit()) {
        return ResUtils.getInnerString($r('app.string.cc_accessibility_str_click')) +
          ResUtils.getInnerString($r('app.string.accessibility_str_long_click_to_drag'));
      }

      return ResUtils.getInnerString($r('app.string.accessibility_str_long_click_to_drag'));
    }
    return '';
  }

  private getFormIsDragable(): boolean {
    return (this.isValidForm || !CheckEmptyUtils.isEmpty(this.formItem.shortcutInfo)) &&
      this.mEvent?.isDragable?.() as boolean;
  }

  private isNeedAccHotArea(): boolean {
    return this.isAccessibilityMode && !this.style.stackAccessibilityLevel &&
      (this.formItem.cardDimension === CommonConstants.CARD_DIMENSION_1x2 ||
        this.formItem.cardDimension === CommonConstants.CARD_DIMENSION_1x1);
  }

  @Styles
  longPressGestureStyles() {
    .parallelGesture(
      GestureGroup(GestureMode.Parallel,
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_ZOOM_IN })
          .onAction((event: GestureEvent) => {
            this.mEvent?.onZoomInLongPress(event);
          }),
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_VIBRATOR_TIME })
          .onAction((event: GestureEvent) => {
            this.mEvent?.onVibratorLongPress(event);
          })
      )
    )
  }

  @Styles
  dragStyles() {
    .draggable(this.getFormIsDragable())
    .onDragStart((event: DragEvent, extraParams?: string) => {
      let item = this.mEvent?.onDragStart(event, extraParams);
      this.isContentVisible = true;
      return item;
    })
    .onDragEnd((event: DragEvent) => this.mEvent?.onDragEnd(event))
    .dragPreviewOptions({
      mode: DragPreviewMode.DISABLE_SCALE,
      modifier: new ImageModifier().borderRadius(this.formItemUIConfig.formRadius *
        this.formItemUIConfig.formScale * this.formItemUIConfig.dragScale)}, {
      // isDragPreviewEnabled: false,
    })
    .dragPreview({ pixelMap: this.mAnimateData.dragSnapshot })
  }

  @Builder
  formItemBuilder() {
    Stack() {
      if (this.enableBlurBackground) {
        Column()
          .width(this.formItemUIConfig.formDisplayWidth)
          .height(this.formItemUIConfig.formDisplayHeight)
          .borderRadius(this.formItemUIConfig.formRadius * this.formItemUIConfig.formScale)
          .backgroundColor($r(`app.color.app_form_back_board`))
      }
      this.buildInterface?.buildView()?.builder({
        formUIConfig: {
          formItem: this.formItem,
          formScale: this.formItemUIConfig.formScale,
          cardId: this.cardId,
          index: this.idIndex,
          formDisplayWidth: this.formItemUIConfig.formDisplayWidth,
          formDisplayHeight: this.formItemUIConfig.formDisplayHeight,
          formRadius: this.formItemUIConfig.formRadius,
          formOpacity: this.formItemUIConfig.formOpacity,
          formHeight: this.formItemUIConfig.formHeight,
          want: this.mEvent?.getFormWant(this.formItem),
          layoutType: this.formItemUIConfig.layoutType,
          isSupportBrightness: this.formItemUIConfig.isSupportBrightness,
          hasFadeInAnimation: this.formItemUIConfig.hasFadeInAnimation,
        },
        event: {
          onAcquired: (cardId: string) => {
            this.cardId = cardId;
            this.mEvent?.onCardAcquired?.(cardId);
            if (!CheckEmptyUtils.checkStrIsEmpty(cardId)) {
              this.isValidForm = true;
            }
          },
          onLoad: () => {
            this.mEvent?.onCardLoad?.(this.cardId);
          },
          onError: (errorMsg) => {
            this.mEvent?.onCardError?.(errorMsg);
          }
        }
      })
    }
    .id(this.mEvent?.getFormItemSnapId())
    .accessibilityGroup(true)
    .accessibilityLevel(this.style.stackAccessibilityLevel ? 'yes' : 'no')
    .accessibilityText(this.formDescriptionVm.mDisplayName)
    .accessibilityDescription(this.getAccessibilityDescription())
    .visibility(this.isContentVisible ? Visibility.Visible : Visibility.Hidden)
    .onClick((event: ClickEvent) => this.mEvent?.onClick(event))
    .attributeModifier(this.formItemUIConfig?.formUpdater)
    .dragStyles()
    .clip(true)
    .overlay(this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK &&
      !this.formItemUIConfig.hiddenStrokes && this.formItemUIConfig.isNeedFormInnerLine ?
      FormInLineBorder.buildView()?.builder({
        borderRadius: this.formItemUIConfig.formRadius * this.formItemUIConfig.formScale,
      }) : null)
  }

  @Builder
  formBuilder() {
    Column() {
      this.formItemBuilder()
    }
    .accessibilityLevel('no')
    .borderRadius(this.formItemUIConfig.formRadius * this.formItemUIConfig.formScale)
    .onTouch((event: TouchEvent) => {
      this.mEvent?.onTouch(event);
    })
    .scale({ x: this.mAnimateData?.animateScale, y: this.mAnimateData?.animateScale })
    .attributeModifier(this.formItemUIConfig?.parentUpdater)
    .longPressGestureStyles()
    .alignItems(this.style.columnAlignItems)
    .onDisAppear(() => {
      log.showInfo('onDisAppear');
    })
    .clip(!this.formItemUIConfig.hiddenStrokes)
    .renderGroup(!this.formItemUIConfig.hiddenStrokes)
  }

  build() {
    // 无障碍下卡片高度为1宫格的卡片
    if (this.isNeedAccHotArea()) {
      Stack() {
        this.formBuilder()
        Column()
          .longPressGestureStyles()
          .dragStyles()
          .draggable(this.isValidForm && FormCenterViewModel.getInstance().getIsSupportDrag())
          .onClick((event: ClickEvent) => this.mEvent?.onClick(event))
          .width(this.formItemUIConfig.formDisplayWidth)
          .height((this.formItemUIConfig.formDisplayHeight ?? 0) * 2)
      }
      .align(Alignment.Center)
    } else {
      this.formBuilder()
    }
  }
}