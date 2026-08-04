/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import { LogHelper, LogDomain, CheckEmptyUtils, SingleContext } from '@ohos/basicutils';
import { launcherStatusUtil } from '@ohos/windowscene';
import { DropAnimationCancelReason } from '@ohos/componentanimator';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import {
  StyleConstants,
  PresetStyleConstants,
  DeviceState,
  CommonConstants,
  CardItemInfo,
  FormHostService,
} from '@ohos/launchercommon';
import { FormStackView } from '@ohos/formstack/src/main/ets/view/FormStackView';
import { FormStackItemInfo } from '@ohos/formstack/src/main/ets/common/FormStackItemInfo';
import { DeskTopItemStyle } from '@ohos/launchercommon/Index';
import FormStyleConstants from '@ohos/form/src/main/ets/default/common/constants/FormStyleConstants';
import { FormStackUtil } from '@ohos/formstack/src/main/ets/common/FormStackUtil';
import { AccessibilityManager } from '@ohos/frameworkwrapper';
import {
  CardNodeControllerManager,
  FormBasicParams,
  FormOccupyParams,
} from '@ohos/launchercommon/src/main/ets/manager/CardNodeControllerManager';
import { CardNodeController } from '@ohos/launchercommon/src/main/ets/buildernode/CardNodeController';
import { FormComponentConfig } from '@ohos/launchercommon/src/main/ets/form/model/FormComponentConfig';
import {
  DesktopFormStackViewModel,
  FormStackItemCommonData,
  FormStackItemViewData,
} from '../viewmodel/DesktopFormStackViewModel';
import { FormViewModel } from '@ohos/form';

const TAG: string = 'FormStackItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * FormStack item, which display on desktop workspace.
 */
@Component
export default struct FormStackItem {
  @Prop singleContext?: SingleContext;
  private readonly mFormStackItem: FormStackItemInfo = new FormStackItemInfo();
  private mNameLines: number = PresetStyleConstants.DEFAULT_APP_NAME_LINES;
  private getIndexInSwiper: Function = (): number => 0;
  private mComponentId: string = '';
  private mViewModel: DesktopFormStackViewModel = new DesktopFormStackViewModel(this.singleContext);
  private mCommonData: FormStackItemCommonData = new FormStackItemCommonData();
  private isOuterDesktop: boolean = false;

  @State mViewData: FormStackItemViewData = new FormStackItemViewData();
  @State mStackTopName: string = '';
  @Consume isDragStart: boolean;
  @Consume translateX: number;
  @Consume translateY: number;
  @ObjectLink @Watch('updateStyle') mDesktopStyle: DeskTopItemStyle;
  @StorageLink('isPortrait') @Watch('onPortraitStatusChange') mIsPortrait: boolean = true;
  @StorageLink('folderStatusMenu') @Watch('onFolderStatusChange') folderStatus: number = DeviceState.DEFAULT_STATE;
  @State mDialogName: Resource = $r('app.string.is_delete_card');
  @StorageLink('foldStatusForOuterScreen') @Watch('folderStatusChangeOuterScreen') foldStatusForOuterScreen: number = DeviceState.DEFAULT_STATE;
  @State isExpandingFoldProductFolded: boolean = launcherStatusUtil.getShowOutLauncherStatus();
  @State animateScale: number = 1.0;
  @State isNeedBlendMode: boolean = false;
  @StorageLink('themeStyle') @Watch('onThemeChange') themeStyle: string = '';

  private onThemeChange(): void {
    log.showInfo(`theme change, formstack[${this.mFormStackItem.formStackId}] refresh config.`);
    if (FormStackUtil.isFormStackLayoutItemInvalid(this.mFormStackItem) || this.isOuterDesktop) {
      log.showError('mFormStackItem is invalid, onThemeChange failed!');
      return;
    }
    this.mViewModel.initViewData(this.mFormStackItem.layoutInfo[0][0].cardDimension, this.isOuterDesktop);
    this.updateNodes();
  }

  private updateNodes(): void {
    const cards: CardItemInfo[] = this.mFormStackItem.layoutInfo[0];
    const mFormComponentConfig: FormComponentConfig = FormComponentConfig.getInstance();
    const mFormComponentStyle = mFormComponentConfig.getFormComponentDisplayStyle(
      this.mFormStackItem.layoutInfo[0][0].cardDimension, { width: this.mViewData.mFormStackItemWidth,
      height: this.mViewData.mFormStackItemHeight });
    for (let i = 0; i < cards.length; i++) {
      // 更新cardNode
      const cardId: string = cards[i].cardId;
      const controller = CardNodeControllerManager.getCardController(cardId) as CardNodeController;
      if (controller) {
        const params = controller.formParams as FormBasicParams;
        if (params instanceof FormBasicParams) {
          params.basicData.width = this.isOuterDesktop ? mFormComponentStyle?.formLayoutSize?.width as number :
            this.mViewData.mFormStackItemWidth;
          params.basicData.height = this.isOuterDesktop ? mFormComponentStyle?.formLayoutSize?.height as number :
            this.mViewData.mFormStackItemHeight;
          params.basicData.borderRadius = this.isOuterDesktop ?
            this.mViewData.mFormBorderRadius / (mFormComponentStyle?.displayRate || 1) :
            this.mViewData.mFormBorderRadius;
          CardNodeControllerManager.getCardNode(cardId)?.update(params);
        }
      }
    }
  }

  private onPortraitStatusChange(): void {
    dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SCREEN_ROTATE);
    // 不可见时不需要下放动效
    if (FormHostService.getInstance().queryInvisibleListItem(this.mFormStackItem.layoutInfo[0][0].cardId)) {
      log.showDebug('formstack invisible, do not need animation');
      this.updateFormSize();
      return;
    }

    animateTo({
      duration: 100,
      curve: Curve.Linear,
    }, () => {
      this.updateFormSize();
    })
  }

  private onFolderStatusChange(): void {
    this.updateFormSize();
  }

  private updateFormSize(): void {
    if (FormStackUtil.isFormStackLayoutItemInvalid(this.mFormStackItem)) {
      log.showError('mFormStackItem is invalid, onPortraitStatusChange failed!');
      return;
    }

    this.mViewModel.onPortraitStatusChange(this.mFormStackItem.layoutInfo[0][0].cardDimension);
    this.updateNodes();
  }

  private folderStatusChangeOuterScreen() {
    if (launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop) &&
    this.mFormStackItem.layoutInfo[0][0].cardDimension) {
      this.mViewModel.initViewData(this.mFormStackItem.layoutInfo[0][0].cardDimension, this.isOuterDesktop)
    };
    if (!launcherStatusUtil.isCurrentDesktopVisible(false)) {
      return;
    }
    this.updateFormSize();
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.isExpandingFoldProductFolded = true;
    } else {
      this.isExpandingFoldProductFolded = false;
    }
  }

  private updateStyle(): void {
    const desktopStyle = this.mDesktopStyle;
    this.translateX = !desktopStyle ? 0 : desktopStyle.translateX;
    this.translateY = !desktopStyle ? 0 : desktopStyle.translateY;
    this.mViewData.mOpacity = !desktopStyle ? 1 : desktopStyle.alpha;
    this.animateScale = !desktopStyle ? 1 : desktopStyle.scale;
    this.isNeedBlendMode = !CheckEmptyUtils.isEmpty(desktopStyle) && desktopStyle.unLockAnimate;
  }

  private getRemoveFormDialogTitle(formName: string): Resource {
    return $r('app.string.is_delete_card', formName);
  }

  aboutToAppear(): void {
    log.showWarn(`aboutToAppear mComponentId: ${this.mComponentId}, getIndexInSwiper(): ${this.getIndexInSwiper()}, ` +
     `page: ${this.mFormStackItem.page}, row: ${this.mFormStackItem.row}, column: ${this.mFormStackItem.column}.`);
    if (FormStackUtil.isFormStackLayoutItemInvalid(this.mFormStackItem)) {
      log.showError('mFormStackItem is invalid, aboutToAppear failed!');
      return;
    }

    this.mViewModel.initEventhubEvent(this.mFormStackItem.formStackId);
    this.mViewModel.initData(this.mViewData);
    this.mViewModel.checkCardDimension(this.mFormStackItem.layoutInfo[0], this.mFormStackItem.area);
    this.mViewModel.initViewData(this.mFormStackItem.layoutInfo[0][0].cardDimension, this.isOuterDesktop);
    this.mViewModel.iniCommonConfigData(this.mCommonData);
    if (AccessibilityManager.getInstance().getIsAccessibilityMode()) {
      AccessibilityManager.getInstance().requestFocusForAccessibility(this.mComponentId, TAG);
    }
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear.');
    this.mViewModel.deInitEventhubEvent(this.mFormStackItem.formStackId);
    this.mViewModel.resetData();
  }

  private getScale(): ScaleOptions {
    return {
      x: this.animateScale,
      y: this.animateScale,
      centerX: this.mDesktopStyle && this.mDesktopStyle.unLockAnimate ? this.mDesktopStyle.centerX :
        FormStyleConstants.FORM_PORTRAIT_SCALE_X,
      centerY: this.mDesktopStyle && this.mDesktopStyle.unLockAnimate ? this.mDesktopStyle.centerY :
        FormStyleConstants.FORM_PORTRAIT_SCALE_Y,
    }
  }

  build() {
    FormStackView({
      singleContext: this.singleContext,
      menuName: this.mStackTopName,
      mFormStackItem: this.mFormStackItem,
      mFormStackItemWidth: this.mViewData.mFormStackItemWidth,
      mFormStackItemHeight: this.mViewData.mFormStackItemHeight,
      mFormStackNameHeight: this.mCommonData.mFormStackNameHeight,
      mFormStackNameWidth: this.mCommonData.mFormStackNameWidth,
      mFormStackNameSize: this.mCommonData.mFormStackNameSize,
      mNameFontColor: this.mCommonData.mNameFontColor,
      mNameLines: this.mNameLines,
      mIconNameMargin: this.mCommonData.mIconNameMargin,
      mIconNameMarginTop: this.mCommonData.mIconNameMarginTop,
      mDragStartFun: (event: DragEvent): DragItemInfo => this.mViewModel.dragStart(this.mFormStackItem, event),
      mFormBorderRadius: this.mViewData.mFormBorderRadius,
      mSizeRatio: this.mCommonData.mSizeRatio,
      getIndexInSwiper: this.getIndexInSwiper,
      mDialogName: this.mDialogName,
      mGetRemoveFormTitleFun: (formName: string): Resource => this.getRemoveFormDialogTitle(formName),
      isNeedBlendMode: this.isNeedBlendMode,
      isOuterDesktop: this.isOuterDesktop,
    })
      .id(this.mComponentId)
      .width(StyleConstants.PERCENTAGE_100)
      .height(StyleConstants.PERCENTAGE_100)
      .align(Alignment.Center)
      .scale(this.getScale())
      .translate({ x: this.translateX, y: this.translateY })
      .opacity(this.isDragStart ? CommonConstants.FORM_HIDDEN_OPACITY : this.mViewData.mOpacity)
      .accessibilityText(this.mViewModel.getStackAccText(this.mFormStackItem))
      .accessibilityDescription(this.mViewModel.getStackAccDescription(this.mStackTopName))
  }
}