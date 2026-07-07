/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import systemparameter from '@ohos.systemParameterEnhance';
import curves from '@ohos.curves';
import { ImageModifier } from '@kit.ArkUI';
import { desktopItemDraggableManager, StyleConstants } from '@ohos/launchercommon';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { AccessibilityManager, GlobalContext, LightOutdoorConfig } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { NumberConstants } from '@ohos/commonconstants';
import { FormStackConstants } from '../common/FormStackConstants';
import { FormStackExpandConfig } from '../common/FormStackExpandConfig';
import { FormStackExpandEventInterface } from '../common/FormStackExpandEventInterface';
import { FormStackExpandItem } from '../viewmodel/FormStackExpandItem';
import { FormStackExpandItemViewData } from '../viewmodel/FormStackExpandItemViewData';
import { FormStackExpandItemEvent } from '../viewmodel/FormStackExpandItemEvent';
import { RTLUtil } from '@ohos/componenthelper';
import { FormStackUtil } from '../common/FormStackUtil';
import { FormComponentConfig } from '@ohos/launchercommon/src/main/ets/form/model/FormComponentConfig'

const TAG: string = 'FormStackExpandItemView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Component
export struct FormStackExpandItemView {
  public mSuperEventInterface?: FormStackExpandEventInterface;
  @Prop isOuterDesktop: boolean = false;
  private mEvent: FormStackExpandItemEvent = new FormStackExpandItemEvent();
  private mDisplayWidth: number = FormStackExpandConfig.getInstance().mDisplayWidth;
  private mFormWidth: number = FormStackExpandConfig.getInstance().mFormWidth;
  private mFormHeight: number = FormStackExpandConfig.getInstance().mFormHeight;
  private mOuterFormStackExpandScale: number = FormComponentConfig.getInstance().mOuterFormStackExpandScale;
  private mFormShowWidth: number = FormStackExpandConfig.getInstance().mFormShowWidth;
  private mFormShowHeight: number = FormStackExpandConfig.getInstance().mFormShowHeight;
  private mLayoutOffsetX: number = FormStackExpandConfig.getInstance().mFormStackOffsetX;
  private mDeleteImageInitOffsetX: number = 0;
  private isNewStyle: boolean = true;
  @Prop mUseEffectComIds: string[] = [];

  @ObjectLink mItemInfo: FormStackExpandItem;
  @State mViewData: FormStackExpandItemViewData = new FormStackExpandItemViewData();
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  private mDeleteFormStackText = '';

  private showItemDelAnimation(): TransitionEffect {
    return this.mItemInfo.isVisible ?
      TransitionEffect.asymmetric(
        TransitionEffect.IDENTITY,
        TransitionEffect.OPACITY.animation({ curve: curves.springMotion(0.4, 0.75) })
          .combine(TransitionEffect.translate({
            x: (RTLUtil.isRTL() ? 1 : -1) *
              (this.mDisplayWidth - (this.mDisplayWidth - this.mFormShowWidth) / 2 + this.mItemInfo.translateX),
          }))
      ) : TransitionEffect.IDENTITY;
  }

  private showTrashDelAnimation(isHead: boolean): TransitionEffect {
    let angle: number = isHead ? FormStackConstants.TRASH_HEAD_ANGLE_MAX : FormStackConstants.TRASH_BODY_ANGLE_MAX;
    return this.mItemInfo.isVisible ?
      TransitionEffect.asymmetric(
        TransitionEffect.IDENTITY,
        TransitionEffect.rotate({ z: 1, centerX: '100%', angle: angle })
          .animation({ curve: curves.springMotion(0.4, 0.75) })
      ) : TransitionEffect.IDENTITY;
  }

  private isDelImgVisible(): boolean {
    if (RTLUtil.isRTL()) {
      return this.mItemInfo.isVisible && this.mItemInfo.delImgVisible && this.mItemInfo.translateX > 0 &&
        (Math.abs(this.mItemInfo.translateX) / (this.mViewData.mDeleteImageMoveLongestDistance) > 0) &&
        this.mViewData.mDeleteImageShow;
    }
    return this.mItemInfo.isVisible && this.mItemInfo.delImgVisible && this.mItemInfo.translateX < 0 &&
      (Math.abs(this.mItemInfo.translateX) / (this.mViewData.mDeleteImageMoveLongestDistance) > 0) &&
      this.mViewData.mDeleteImageShow;
  }

  private getDelImgOpacity(): number {
    if (RTLUtil.isRTL()) {
      return this.mItemInfo.translateX < 0 ?
        0 : Math.abs(this.mItemInfo.translateX) / (this.mViewData.mDeleteImageMoveLongestDistance || 1)
    }
    return this.mItemInfo.translateX > 0 ?
      0 : Math.abs(this.mItemInfo.translateX) / (this.mViewData.mDeleteImageMoveLongestDistance || 1)
  }

  aboutToAppear() {
    if (!this.mItemInfo) {
      log.showError('aboutToAppear, itemInfo is invalid.');
      return;
    }
    log.showInfo(`aboutToAppear id: ${this.mItemInfo.idStr}, translateY: ${this.mItemInfo.translateY}.`);
    this.mViewData.initData(this.mItemInfo, this.mSuperEventInterface as FormStackExpandEventInterface);
    this.mEvent.initData(this.mViewData, this.mSuperEventInterface as FormStackExpandEventInterface);

    this.mDeleteImageInitOffsetX = this.mViewData.mFormMargin < FormStackConstants.DELETE_IMAGE_MARGIN_LEFT_MIN ?
      0 : -FormStackConstants.DELETE_IMAGE_WIDTH;
    log.showInfo(`id: ${this.mItemInfo.idStr}, offsetX: ${this.mDeleteImageInitOffsetX}.`);
    this.isNewStyle = (systemparameter.getSync('sceneboard.isNewStyle', 'true') === 'true');

    if (this.isAccessibilityMode) {
      this.mDeleteFormStackText = ResUtils.getInnerString($r('app.string.delete_form_stack_text'));

      if (this.mItemInfo.zIndex === 0) {
        AccessibilityManager.getInstance().requestFocusAccessibility(`${this.mItemInfo.getId()}`);
        AccessibilityManager.getInstance().sendTextAnnouncedForAccessibility(
          ResUtils.getInnerString($r('app.string.expand_stack_text')), 'textAnnouncedForExpandStack');
      }
    }
  }

  private getAccessibilityText(): string {
    if (!this.isAccessibilityMode) {
      return '';
    }
    return this.mViewData.mCardInfo.appName ?? '';
  }

  private getAccessibilityDescription(): string {
    if (!this.isAccessibilityMode) {
      return '';
    }
    return ResUtils.getInnerStringNumS($r('app.string.expand_stack_request_focus_front_text'),
      this.mItemInfo.zIndex + 1) +
      ResUtils.getInnerPluralByResource($r('app.plural.expand_stack_request_focus_after_text'),
      this.mEvent.getFormStackItemList());
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear, id: ${this.mItemInfo?.idStr}.`);
    this.mViewData.resetData();
    this.mEvent.resetData();
    this.mSuperEventInterface = undefined;
  }

  @Styles
  panGestureStyle() {
    .gesture(
      PanGesture()
        .onActionStart((event: GestureEvent) => {
          this.mEvent.onPanGestureStart(event);
        })
        .onActionUpdate((event: GestureEvent) => {
          this.mEvent.onPanGestureMove(event);
        })
        .onActionEnd((event: GestureEvent) => {
          this.mEvent.onPanGestureEnd(event);
        }))
  }

  @Styles
  longPressGestureStyle() {
    .parallelGesture(
      GestureGroup(GestureMode.Parallel,
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_VIBRATOR_TIME })
          .onAction(() => {
            if (this.mItemInfo.isDraggable) {
              this.mEvent.onLongPressGesture();
            }
          }),
        LongPressGesture({ repeat: false, duration: FormStackConstants.FORMSTACK_EXPAND_HIDE_DEL_IMAGE_TIME })
          .onAction(() => {
            if (this.mItemInfo.isDraggable) {
              this.mItemInfo.delImgVisible = false;
            }
          }),
      )
    )
  }

  @Styles
  dragStyles() {
    .onDragStart((event?: DragEvent) => {
      return this.mEvent.onDragStart(event);
    })
    .onDragEnd((event?: DragEvent) => {
      this.mEvent.onDragEnd(event);
    })
    .dragPreviewOptions({
      mode: DragPreviewMode.DISABLE_SCALE,
      modifier: new ImageModifier().borderRadius(FormStackExpandConfig.getInstance().mFormRadius)
    }, {
      // isDragPreviewEnabled: false
    })
    .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
      if (gestureInfo.type === GestureControl.GestureType.DRAG && !desktopItemDraggableManager.getEnableDrag()) {
        return GestureJudgeResult.REJECT;
      }
      // 云端2预制元素禁止拖拽
      if (gestureInfo.type === GestureControl.GestureType.DRAG &&
      LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
        return GestureJudgeResult.REJECT;
      }
      return GestureJudgeResult.CONTINUE;
    })
  }

  build() {
    if (this.mViewData.mVisible && !CheckEmptyUtils.isEmpty(this.mItemInfo)) {
      Stack() {
        this.stackFormItem();
        this.deleteImage();
        if (this.mItemInfo.maskNeedRender) {
          this.stackMaskItem();
        }
      }
      .id(`${TAG}_${this.mItemInfo.idStr}_ROW`)
      .width(StyleConstants.PERCENTAGE_100)
      .height(this.mFormShowHeight)
      .alignContent(Alignment.TopStart)
      .translate({ y: this.mItemInfo.translateY + this.mItemInfo.longPressAvoidY + this.mItemInfo.slideAvoidY })
      .zIndex(this.mItemInfo.zIndex)
      .panGestureStyle()
      .transition(this.showItemDelAnimation())
      .opacity(this.mItemInfo.isVisible ? 1 : 0)
    }
  }

  // 外屏比例缩放
  private getOuterScaleRatio() : number {
    if (this.isOuterDesktop && !this.mItemInfo.isAiCard) {
      return this.mOuterFormStackExpandScale;
    }
    return 1;
  }

  @Styles
  formCommonStyle() {
    .width(this.mFormWidth / this.getOuterScaleRatio())
    .height(this.mFormHeight / this.getOuterScaleRatio())
    .scale({
      x: this.mItemInfo.scaleX * this.getOuterScaleRatio(),
      y: this.mItemInfo.scaleY * this.getOuterScaleRatio()
    })
    .borderRadius(FormStackExpandConfig.getInstance().mFormRadius * this.getOuterScaleRatio())
    .rotate({
      x: FormStackConstants.FORM_STACK_OPEN_ROTATE_POINT_X,
      centerY: FormStackConstants.FORM_STACK_OPEN_ROTATE_POINT_CENTER_Y,
      angle: this.mItemInfo.rotateX,
    })
  }

  @Builder
  stackMaskItem() {
    Column() {
      Column() {
      }
      .formCommonStyle()
      .backgroundColor(this.currColorMode === 0 ? '#e67e7f80' : '#FFD7D8D9')
      .opacity(this.mItemInfo.maskOpacity)
    }
    .width(this.mFormShowWidth)
    .height(this.mFormShowHeight)
    .position({
      x: this.mLayoutOffsetX + this.mItemInfo.translateX,
    })
  }

  @Builder
  stackFormItem() {
    Column() {
      this.stackFormImage()
    }
    .id(this.mItemInfo.getId())
    .width(this.mFormShowWidth)
    .height(this.mFormShowHeight)
    .opacity(this.mItemInfo.opacity)
    .draggable(this.mItemInfo.isDraggable)
    .position({
      x: this.mLayoutOffsetX + this.mItemInfo.translateX,
    })
    .onTouch((event?: TouchEvent) => {
      this.mEvent.onTouch(event);
    })
    .onClick(() => {
      this.mEvent.onClick(this.mItemInfo.idStr);
    })
    .longPressGestureStyle()
    .dragStyles()
    .accessibilityText(this.getAccessibilityText())
    .accessibilityDescription(this.getAccessibilityDescription())
  }

  @Builder
  deleteImage() {
    Button({
      type: ButtonType.Circle,
      stateEffect: true
    }) {
      Stack({ alignContent: Alignment.TopStart }) {
        Image($r('app.media.edit_delete_img_head')).draggable(false)
          .objectFit(ImageFit.Contain)
          .fillColor('#ffffffff')
          .width(StyleConstants.DEFAULT_24)
          .height(StyleConstants.DEFAULT_24)
          .rotate({ z: 1, centerX: '100%', angle: this.mItemInfo.trashHeadAngle })
        Image($r('app.media.edit_delete_img_body')).draggable(false)
          .objectFit(ImageFit.Contain)
          .fillColor('#ffffffff')
          .width(StyleConstants.DEFAULT_24)
          .height(StyleConstants.DEFAULT_24)
          .rotate({ z: 1, centerX: '100%', angle: this.mItemInfo.trashBodyAngle })
      }
    }
    .width(StyleConstants.DEFAULT_40)
    .height(StyleConstants.DEFAULT_40)
    .backgroundColor('#E84026')
    .position({
      x: this.mViewData.mDeleteImgTranslateX,
      y: this.mItemInfo.delImgShowHeight < FormStackConstants.DELETE_IMAGE_HEIGHT ?
        0 : (this.mItemInfo.delImgShowHeight - FormStackConstants.DELETE_IMAGE_HEIGHT) / 2,
    })
    .opacity(this.getDelImgOpacity())
    .visibility(this.isDelImgVisible() ? Visibility.Visible : Visibility.Hidden)
    .onClick(() => {
      this.mEvent.onDeleteImgClick();
    })
    .accessibilityText(this.isAccessibilityMode ? this.mDeleteFormStackText : '')
  }

  @Builder
  stackFormImage() {
    if (this.mItemInfo.enableBlurBackground) {
      Stack() {
        // 模糊背板
        Column()
          .width('100%')
          .height('100%')
          .useEffect(true)
          .borderRadius(FormStackExpandConfig.getInstance().mFormRadius * this.getOuterScaleRatio())
        // 适配深浅色模式的颜色背板
        Column()
          .backgroundColor($r(`app.color.app_form_back_board`))
          .opacity(0.85)
          .width('100%')
          .height('100%')
          .borderRadius(FormStackExpandConfig.getInstance().mFormRadius * this.getOuterScaleRatio())
        NodeContainer(this.mItemInfo.cardNode)
          .width('100%')
          .height('100%')
          .borderRadius(FormStackExpandConfig.getInstance().mFormRadius * this.getOuterScaleRatio())
      }
      .draggable(false)
      .formCommonStyle()
      .brightness(this.mItemInfo.bgBrightness)
      .id(`${this.mItemInfo.getId()}_image`)
      .visibility(this.mItemInfo.isVisible ? Visibility.Visible : Visibility.Hidden)
      .shadow(this.isNewStyle ? {
        radius: this.mItemInfo.shadowRadius,
        color: FormStackConstants.FORM_SHADOW_COLOR,
      } : null)
      .useEffect(this.mUseEffectComIds.includes(FormStackUtil.getSplitFormId(this.mItemInfo.idStr)))
      .enabled(false)
    } else {
      NodeContainer(this.mItemInfo.cardNode)
        .draggable(false)
        .formCommonStyle()
        .brightness(this.mItemInfo.bgBrightness)
        .id(`${this.mItemInfo.getId()}_image`)
        .visibility(this.mItemInfo.isVisible ? Visibility.Visible : Visibility.Hidden)
        .shadow(this.isNewStyle ? {
          radius: this.mItemInfo.shadowRadius,
          color: FormStackConstants.FORM_SHADOW_COLOR,
        } : null)
        .useEffect(this.mUseEffectComIds.includes(FormStackUtil.getSplitFormId(this.mItemInfo.idStr)))
        .enabled(false)
    }
  }
}