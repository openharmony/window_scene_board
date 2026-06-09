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

import I18n from '@ohos.i18n';
import { ComponentContent } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import {
  CheckEmptyUtils,
  JsonUtils,
  LogDomain,
  LogHelper,
  SingleContext
} from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { NumberConstants } from '@ohos/commonconstants';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { FormComponentVm } from '@ohos/launchercommon/Index';
import {
  AppLockManager,
  AppLockStatusEnum,
  CardItemInfo,
  CommonConstants,
  DeviceState,
  EditModeUtils,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  LayoutDescription,
  LiveFormSupportMgr,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { OpenFolderGridSwiperLayout } from '@ohos/bigfolder/src/main/ets/default/viewmodel/OpenFolderGridSwiperLayout';
import { openFolderLayout } from '@ohos/bigfolder/src/main/ets/default/viewmodel/OpenFolderLayout';
import { FormStyleConfig, FormViewModel } from '@ohos/form';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { OverflowConstants, RotationConstants } from '@ohos/commonconstants/src/main/ets/constants/SCBConstants';
import { formInfo } from '@kit.FormKit';
import {
  OverflowFormConnectionType,
  OverflowFormDisconnectionType,
  OverflowFormStatus,
  OverflowFormVm,
  OverflowFormIconConfig,
  ConnectionInfo,
} from '../viewmodel/OverflowFormVm';
import { OverflowFunInteractionFormEvent } from '../event/OverflowFunInteractionFormEvent';
import { OverflowSceneAnimationFormEvent } from '../event/OverflowSceneAnimationFormEvent';
import { OverflowFormStatusController } from '../controller/status/OverflowFormStatusController';
import OverflowFormUtils, { DisableGesture } from '../common/OverflowFormUtils';
import { ExtensionPlaceholderParams, OverflowViewModel } from '../viewmodel/OverflowViewModel';
import { OverflowFunInteractionFormStatusController } from '../controller/status/OverflowFunInteractionFormStatusController';
import { OverflowSceneAnimationFormStatusController } from '../controller/status/OverflowSceneAnimationFormStatusController';

const TAG = 'OverflowFormItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const OVERFLOW_PANGESTURE_TIMER: number = 15;
const PAN_GESTURE_MIN_DISTANCE: number = 1;
const DEFAULT_POSTION_X: number = 0;
const DEFAULT_POSTION_Y: number = 0;
const OVERFLOW_FORM_HOT_AREA_EXTEND: number = 12;
const ERROR_CODE_UIEXTENSION_EXITED_ABNORMALLY: number = 100014;
const OVERFLOW_FORM_ICON_CONFIG: Record<string, OverflowFormIconConfig> = {
  'small':  { pauseIconSize: 24, pauseIconPadding: 12, iconSize: 32, iconSpace: 16 },
  'medium': { pauseIconSize: 30, pauseIconPadding: 12, iconSize: 40, iconSpace: 16 },
  'large':  { pauseIconSize: 36, pauseIconPadding: 14, iconSize: 56, iconSpace: 32 }
};
const LIVE_FORM_CLICK_TIMEOUT_MS = 200;
const UNDEFINED_TIME_ID = -1;
const IMAGE_DECODED_FINISH: number = 1;

@Builder
function extensionPlaceholder(param: ExtensionPlaceholderParams) {
  Image(param.getPixelMap())
    .width(param.getWidth())
    .height(param.getHeight())
    .borderRadius(param.getCornerRadius())
    .objectFit(ImageFit.Fill)
    .clip(true)
}

@Component
export default struct OverflowFormItem {
  @Prop singleContext?: SingleContext;
  // 卡片基础信息
  private mFormItem: CardItemInfo = new CardItemInfo();
  private getIndexInSwiper: Function = (): number => 0;
  private mOverflowFormItemEvent: OverflowFunInteractionFormEvent
    | OverflowSceneAnimationFormEvent | undefined = undefined;
  private mFormComponentBuilderId: string = '';
  private mFormRelativeItemId: string = '';
  private gameFormIndex = 0;
  private uiExtProxy: UIExtensionProxy | null = null;
  private mFormStyleConfig: FormStyleConfig = FormViewModel.getInstance(this.singleContext).getFormStyleConfig();
  private mOverflowFormStatusController?: OverflowFormStatusController;
  private mActiveFormTouchTimer?: number;
  private isOuterDesktop: boolean = false;
  private mOverflowFormIconConfig: OverflowFormIconConfig = OVERFLOW_FORM_ICON_CONFIG['medium'];
  private timeId: number = UNDEFINED_TIME_ID;

  @State mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
  @Prop mFormComponentVm: FormComponentVm;
  @Prop mFormBorderRadius: number = ResUtils.getNumber($r('app.float.form_corner_radius'));
  @Prop scaleX: number = 1;
  @Prop scaleY: number = 1;
  @Consume isDragStart: boolean;
  @Watch('updateSwiperPageIndex') @StorageProp('pageIndex') pageIndex: number = 0;
  @Watch('updateSwiperPageIndex') @StorageProp('outerPageIndex') outerPageIndex: number = 0;

  // 卡片布局信息变化相关监听
  @Watch('onFormRectChanged') @Prop mFormItemWidth: number = 0;
  @Watch('onFormRectChanged') @Prop mFormItemHeight: number = 0;
  @Watch('onThemeChanged') @StorageProp('themeStyle') themeStyle: string = '';
  @Watch('onScreenSizeChanged') @StorageProp('screenWidth') screenWidth: number = 0;
  @Watch('onScreenSizeChanged') @StorageProp('screenHeight') screenHeight: number = 0;

  // 卡片状态变化相关监听
  @Watch('canUpdateStatusChange') @State canUpdateStatus: boolean = true;
  @Watch('onActiveFormChanged') @StorageLink('activeForm') activeForm: GridLayoutItemInfo | undefined = undefined;
  @Watch('onDeskTopChanged') @StorageProp('onDeskTop') isDeskTopGainFocus: boolean = true;
  @Watch('isStartExitAnimationChanged')
    @StorageProp('isDuringStartExitAnimation') isDuringStartExitAnimation: boolean = false;
  @Watch('onFolderStatusChange') @StorageLink('folderStatus') mFolderStatus: number = DeviceState.DEFAULT_STATE;
  @Watch('onScreenRotationChange') @StorageLink('screenRotation') mScreenRotation: number =
    RotationConstants.ROTATION_INVALIDED;

  @Watch('onGameFormPositionChange') @Consume translateX: number;
  @Watch('onGameFormPositionChange') @Consume translateY: number;
  @Watch('onGameFormPositionChange') @Consume isInDrag: boolean;

  @Watch('onChangeStatusDirectly') @State gridSwiperLayout: OpenFolderGridSwiperLayout =
    openFolderLayout.getGridSwiperLayout();
  @Watch('onChangeStatusDirectly') @StorageProp('showRecent') showRecent: boolean = false;
  @Watch('onChangeStatusDirectly') @StorageLink('isInScreenSnapshot') isInScreenSnapshot: boolean = false;

  @Watch('onChangeStatusWithAnimation') @StorageProp('isDrag') isDrag: boolean = false;
  @Watch('onChangeStatusWithAnimation') @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @Watch('onChangeStatusWithAnimation') @StorageProp('isNormalDesktopMode') isNormalDesktopMode: boolean = true;
  @Watch('onAppLockCacheChange') @StorageProp('onAppLockCache') appLockCache: Map<string, boolean> = new Map();
  @Watch('onGridSwiperGesture') @StorageProp('isInGridSwiperGesture') isInGridSwiperGesture: boolean = false;
  @Consume dragSnapshot?: image.PixelMap;
  @State overflowSnapshot?: image.PixelMap = undefined;

  private mOverflowViewModel: OverflowViewModel = OverflowViewModel.getInstance();
  private isFunInteraction: boolean = true;
  private isSystemApp = false;
  private extComponentContent?: ComponentContent<ExtensionPlaceholderParams>;
  private startOverflowFormTimeout?: number;
  private canSupportPauseStatus: boolean = false;

  private setOverflowSnapshot(formImage: image.PixelMap): void {
    log.showInfo('setOverflowSnapshot, formImage: %{public}s', formImage.getImageInfoSync());
    this.overflowSnapshot = formImage;
  }

  private releaseOverflowSnapshot(): void {
    if (!this.overflowSnapshot) {
      log.showInfo('releaseOverflowSnapshot, old overflowSnapshot has released, id: %{public}s',
        this.mFormItem.cardId);
      return;
    }
    this.overflowSnapshot.release()
      .then(() => {
        log.showInfo('releaseOverflowSnapshot, release old overflowSnapshot, id: %{public}s', this.mFormItem.cardId);
      })
      .catch((error: string) => {
        log.showInfo('releaseOverflowSnapshot, release old overflowSnapshot, id: %{public}s, error: %{public}s',
          this.mFormItem.cardId, error);
      });
    this.overflowSnapshot = undefined;
  }

  private onGridSwiperGesture(): void {
    if (this.isFunInteraction) {
      return;
    }
    let event: OverflowSceneAnimationFormEvent = this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent;
    if (event.isLongActiveForm() && this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.ACTIVE) {
      event.notifyStatusChange(this.isInGridSwiperGesture ?
        OverflowConstants.START_SWIPE : OverflowConstants.END_SWIPE);
      return;
    }
    if (this.isInGridSwiperGesture && this.isSystemApp && !event.isLongActiveForm() &&
      this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.ACTIVE) {
      this.stopOverflow(false);
    }
  }

  private stopActive(hasAnimation: boolean, isSwipe: boolean = false): void {
    if (this.isFunInteraction) {
      this.stopOverflow(hasAnimation);
      return;
    }
    let event: OverflowSceneAnimationFormEvent = this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent;
    if (!event.isLongActiveForm()) {
      this.stopOverflow(hasAnimation);
      return;
    }
    if (!this.canSupportPauseStatus) {
      log.showInfo(`stopActive can not support pause status: ${this.canSupportPauseStatus}`);
      event.stopOverflow(hasAnimation, false);
      return;
    }

    // 长时激活卡片，切换到暂停态， extensionComponent 切换到后台
    if (this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.ACTIVE) {
      event.stopLongActiveFormActive(!isSwipe);
    }
  }

  private stopOverflow(hasAnimation: boolean): void {
    // 游戏卡片，停止溢出时候，直接进入暂停态
    if (this.isFunInteraction) {
      this.registerOperation(OverflowFormStatus.PAUSE, hasAnimation);
      return;
    }

    // 场景动效卡片
    let event: OverflowSceneAnimationFormEvent = this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent;
    log.showInfo('stopOverflow isRequestOverflow: %{public}s, isLongActive: %{public}s',
      event.isRequestOverflow(), event.isLongActiveForm());
    if (event.isRequestOverflow()) {
      (this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent).stopOverflow(hasAnimation, false);
    }
  }

  private resumeActive(hasAnimation: boolean): void {
    // 游戏卡片需要用户手动操作才可恢复
    if (this.isFunInteraction) {
      return;
    }
    if (!this.canSupportPauseStatus) {
      log.showInfo(`resumeActive can not support pause status: ${this.canSupportPauseStatus}`);
      return;
    }
    if (!this.isReadyChangeActive()) {
      log.showInfo('resumeActive form is not ready to active, formId: %{public}s', this.mFormItem.cardId);
      return;
    }
    let event: OverflowSceneAnimationFormEvent = this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent;
    log.showInfo('resumeActive isRequestOverflow: %{public}s, isLongActive: %{public}s',
      event.isRequestOverflow(), event.isLongActiveForm());
    event.resumeLongActiveFormActive(hasAnimation);
  }

  private onAppLockCacheChange(): void {
    log.showInfo(`appLockCacheChange, isFunInteraction:${this.isFunInteraction}`);
    if (this.isFunInteraction) {
      return;
    }
    let isLocked = AppLockManager.getInstance().getAppLockStatus(this.mFormItem.bundleName, 0);
    log.showInfo(`appLockCacheChange, bundleName:${this.mFormItem.bundleName}, isLocked:${isLocked}`);
    if (isLocked === AppLockStatusEnum.LOCK) {
      this.mOverflowFormVm.overflowFormDisconnectionType = OverflowFormDisconnectionType.APP_LOCK_CHANGE_EXIT;
      let event: OverflowSceneAnimationFormEvent = this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent;
      this.registerOperation(OverflowFormStatus.INACTIVE,
        (this.isSystemApp || !event.useDefaultAnimation()) ? false : true);
    }
  }

  private isStartExitAnimationChanged(): void {
    log.showInfo(`isStartExitAnimationChanged, ${this.isDuringStartExitAnimation}`);
  }

  private isOnDesktopStatus(): boolean {
    log.showInfo(`isOnDesktopStatus, isDeskTopGainFocus: ${this.isDeskTopGainFocus}` +
      `, cardId: ${this.mFormItem.cardId}`);
    return this.isDeskTopGainFocus;
  }

  private isSkipFocusCheck(): boolean {
    let isSkipFocusCheck: boolean =
      this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.INACTIVE && this.mFormItem.isDefaultActivated;
    log.showWarn(`could skip focus check: ${isSkipFocusCheck}, cardId ${this.mFormItem.cardId}`);
    return isSkipFocusCheck;
  }

  private isReadyChangeActive(): boolean {
    return !this.canPauseDirectly() && !this.canPauseWidthAnimation() &&
      (this.isOnDesktopStatus() || this.isSkipFocusCheck());
  }

  private updateSwiperPageIndex(): void {
    let indexInSwiper: number = this.getIndexInSwiper();
    if (this.mFolderStatus !== DeviceState.DEFAULT_STATE && indexInSwiper % 2 == 1) {
      indexInSwiper = indexInSwiper - 1;
    }
    log.showInfo(`updateSwiperPageIndex, isOuterDesktop: ${this.isOuterDesktop}, pageIndex: ${this.getPageIndex()}, indexInSwiper: ${indexInSwiper}`);
    let isPageChanged: boolean = indexInSwiper !== this.getPageIndex();
    if (isPageChanged && this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.ACTIVE) {
      log.showInfo(`updateSwiperPageIndex, change active overflow form item status when swipe page success`);
      this.mOverflowFormVm.overflowFormDisconnectionType = OverflowFormDisconnectionType.SWIPERPAGE_CHANGE_EXIT;
      this.stopActive(false, true);
      return;
    }

    // 卡片位于当前页面，恢复处于暂停态的场景动效卡片
    if (!isPageChanged && !this.isFunInteraction &&
      this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.PAUSE) {
      this.resumeActive(false);
    }
  }

  private canPauseDirectly(): boolean {
    log.showInfo(`canPauseDirectly: showRecent: ${this.showRecent}` +
      `, isShowOpenFolder: ${this.gridSwiperLayout.isShowOpenFolder}`);
    return this.showRecent || this.gridSwiperLayout.isShowOpenFolder;
  }

  private canPauseWidthAnimation(): boolean {
    let indexInSwiper: number = this.getIndexInSwiper();
    if (this.mFolderStatus !== DeviceState.DEFAULT_STATE && indexInSwiper % 2 == 1) {
      indexInSwiper = indexInSwiper - 1;
    }
    log.showInfo(`canPauseWidthAnimation: isOuterDesktop: ${this.isOuterDesktop}, pageIndex: ${this.getPageIndex()}, indexInSwpiper: ${indexInSwiper}` +
      `, isNormalDesktopMode: ${this.isNormalDesktopMode}`);
    return this.getPageIndex() !== indexInSwiper || !this.isNormalDesktopMode;
  }

  private onDeskTopChanged(): void {
    if (!this.isOnDesktopStatus()) {
      log.showInfo('onDeskTopChanged, change active overflow form item status when not on desktop' +
        ', cardId: %{public}s', this.mFormItem.cardId);
      this.handleDesktopLoseFocus();
      return;
    }

    log.showInfo('onDeskTopChanged, overflowFormStatus: %{public}s, isFunInteraction: %{public}s' +
      ', isDrag: %{public}s, isInDrag: %{public}s', this.mOverflowFormVm.overflowFormStatus, this.isFunInteraction,
      this.isDrag, this.isInDrag);
    if (this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.PAUSE && !this.isFunInteraction &&
      !this.isDrag && !this.isInDrag) {
      this.resumeActive(false);
      return;
    }
  }

  private onScreenSizeChanged(): void {
    log.showInfo(`onScreenSizeChanged, mScreenRotation`);
    if (!this.isFunInteraction) {
      return;
    }
    this.mOverflowFormVm.uiExtensionComponentWidth = this.screenWidth;
    this.mOverflowFormVm.uiExtensionComponentHeight = this.screenHeight;
    this.mOverflowFormVm.overflowFormHotAreaOffsetX =
      (this.mOverflowFormVm.uiExtensionComponentWidth - this.mFormItemWidth) / NumberConstants.CONSTANT_NUMBER_TWO;
    this.mOverflowFormVm.overflowFormHotAreaOffsetY =
      (this.mOverflowFormVm.uiExtensionComponentHeight - this.mFormItemHeight) / NumberConstants.CONSTANT_NUMBER_TWO;
  }

  private onThemeChanged(): void {
    this.updateBorderRadius();
  }

  private onScreenRotationChange(): void {
    log.showInfo('onScreenRotationChange, mScreenRotation: %{public}d', this.mScreenRotation);
    this.mOverflowFormVm.overflowFormDisconnectionType = OverflowFormDisconnectionType.SCREEN_ROTATION_CHANGE_EXIT;
    if (this.isFunInteraction) {
      this.onStatusChange();
      return;
    }

    let event: OverflowSceneAnimationFormEvent = this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent;
    if (event.isLongActiveForm()) {
      log.showInfo('onScreenRotationChange, long active form, stop overflow');
      event.stopLongActiveFormOverflowWhenRotation();
    } else {
      this.onStatusChange();
    }
  }

  private onFolderStatusChange(): void {
    log.showInfo('onFolderStatusChange, mFolderStatus: %{public}d', this.mFolderStatus);
    this.mOverflowFormVm.overflowFormDisconnectionType = OverflowFormDisconnectionType.FOLDER_STATUS_CHANGE_EXIT;
    if (this.isFunInteraction) {
      this.onStatusChange();
      return;
    }
    let event: OverflowSceneAnimationFormEvent = this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent;
    let isFormActive: boolean = this.isFormActive();
    let isLongActiveForm: boolean = event.isLongActiveForm();
    log.showInfo(`onFolderStatusChange isFormActive: ${isFormActive}, isLongActive: ${isLongActiveForm}`);
    if (isFormActive && isLongActiveForm) {
      this.registerOperation(OverflowFormStatus.INACTIVE, false);
      return;
    }
    this.onStatusChange();
  }

  private onStatusChange(): void {
    if (!this.isFormActive()) {
      log.showInfo('onChangeStatusDirectly: is not active card');
      return;
    }
    this.stopOverflow(false);
  }

  private updateBorderRadius(): void {
    if (!this.mFormItem || !this.mFormItem.cardDimension) {
      log.showInfo('updateBorderRadius: card dimension info is null');
      return;
    }
    let formRadiusFromConfig: number = this.mFormStyleConfig.getFormBorderRadius(this.mFormItem.cardDimension);
    let isRadiusChange: boolean = formRadiusFromConfig !== CommonConstants.INVALID_VALUE &&
      this.mFormBorderRadius !== formRadiusFromConfig;
    if (!isRadiusChange || !this.isFunInteraction) {
      log.showInfo(`updateBorderRadius: do not have to update radius` +
        `, isRadiusChange: ${isRadiusChange}, isQuickGame: ${this.isFunInteraction}`);
      return;
    }
    log.showInfo(`updateFormRadius: mFormItemVm.mFormBorderRadius: ${this.mFormBorderRadius}`);
    try {
      this.uiExtProxy?.send({
        'radiusChange': JsonUtils.toJson({ 'radius': this.mFormBorderRadius })
      });
    } catch (error) {
      log.showError(`updateBorderRadius: overflow card send data faild, ${error?.code} ${error?.message},` +
        ` formId:${this.mFormItem.cardId}`);
    }
  }

  private onFormRectChanged(): void {
    if (!this.mFormItem || !this.mFormItem.cardDimension) {
      log.showInfo('onFormRectChanged: form item cardDimension is wrong');
      return;
    }
    if (!this.isFunInteraction) {
      log.showInfo(`onFormRectChanged: game type is wrong, ${this.isFunInteraction}`);
      return;
    }
    let rect: number[] = [DEFAULT_POSTION_X, DEFAULT_POSTION_Y, this.mFormItemWidth, this.mFormItemHeight];
    log.showInfo(`onFormRectChanged, rect: ${rect}`);
    try {
      this.uiExtProxy?.send({
        'onRegionChange': JsonUtils.toJson({
          'rect': rect
        })
      });
    } catch (error) {
      log.showError(`overflow card send data faild, ${error?.code} ${error?.message}, formId:${this.mFormItem.cardId}`);
    }
  }

  /**
   * 用户操作导致 overflow form 状态切换，无动效
   */
  private onChangeStatusDirectly(): void {
    if (this.isFormActive()) {
      if (this.canPauseDirectly() || this.isInScreenSnapshot) {
        log.showInfo(`onChangeStatusDirectly, isInScreenSnapshot: ${this.isInScreenSnapshot}`);
        this.stopActive(false);
      }
      return;
    }
    if (this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.PAUSE && !this.isFunInteraction) {
      this.resumeActive(false);
      return;
    }
  }

  /**
   * 用户操作导致 overflow form 状态切换，有动效
   */
  private onChangeStatusWithAnimation(): void {
    let canPasue: boolean = this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.ACTIVE ||
      (this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.PAUSE && this.mOverflowFormVm.isInLongPress);
    let canResume: boolean = !this.isFunInteraction;
    log.showInfo('onChangeStatusWithAnimation, overflowFormStatus: %{public}d, isInLongPress: %{public}s' +
      ', isDrag: %{public}s, isInDrag: %{public}s, canPasue: %{public}s, canResume: %{public}s',
      this.mOverflowFormVm.overflowFormStatus, this.mOverflowFormVm.isInLongPress,
      this.isDrag, this.isInDrag, canPasue, canResume);
    if (!canPasue && !canResume) {
      return;
    }
    if (canPasue && this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.ACTIVE) {
      this.onPauseWithAnimationWhenActive();
      return;
    }
    if (canPasue && this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.PAUSE &&
      this.mOverflowFormVm.isInLongPress && !this.isInDrag && this.isDrag) {
      this.stopActive(true);
      return;
    }
    this.onResumeWithAnimationWhenPause(canResume);
  }

  private onPauseWithAnimationWhenActive(): void {
    let canPauseOverflowForm: boolean = this.canPauseWidthAnimation() || this.isDrag;
    log.showInfo(`onPauseWithAnimationWhenActive isDrag: ${this.isDrag}`);
    if (!canPauseOverflowForm) {
      return;
    }
    this.stopActive(true);
  }

  private onResumeWithAnimationWhenPause(canResume: boolean): void {
    if (canResume && !this.isDrag && !this.isInDrag &&
      this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.PAUSE) {
      this.resumeActive(true);
    }
  }

  private updateOverflowFormIndex(): void {
    let layoutDescription: LayoutDescription = LaunchLayoutCacheManager.getInstance().selectLayoutDescription();
    this.gameFormIndex = (this.getIndexInSwiper() * layoutDescription.row * layoutDescription.column) +
      ((this.mFormItem.column ?? 0) * layoutDescription.row) + (this.mFormItem.row ?? 0);
  }

  private onGameFormPositionChange(): void {
    let skipFunInteractionForm: boolean = this.isFunInteraction &&
      this.mOverflowFormVm.overflowFormStatus !== OverflowFormStatus.PAUSE;
    let skipSceneAnimationForm: boolean = !this.isFunInteraction &&
      this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.INACTIVE;
    if (this.isInDrag || skipFunInteractionForm || skipSceneAnimationForm) {
      log.showInfo(`onGameFormPositionChange: can not change, isInDrag: ${this.isInDrag}` +
        `, overflowFormStatus: ${this.mOverflowFormVm.overflowFormStatus}, isFunInteraction: ${this.isFunInteraction}`);
      return;
    }
    let layoutDescription: LayoutDescription = LaunchLayoutCacheManager.getInstance().selectLayoutDescription();
    const index = (this.getIndexInSwiper() * layoutDescription.row * layoutDescription.column) +
      ((this.mFormItem.column ?? 0) * layoutDescription.row) + (this.mFormItem.row ?? 0);
    log.showInfo(`onGameFormPositionChange:  isDragStart: ${this.isDragStart}, isInDrag: ${this.isInDrag}` +
      `, isOuterDesktop: ${this.isOuterDesktop}, this.pageIndex: ${this.getPageIndex()}, indexInSwiper: ${this.getIndexInSwiper()}` +
      `, gameFormIndex: ${this.gameFormIndex}, index: ${index}`);
    if (this.gameFormIndex !== index) {
      this.mOverflowFormVm.overflowFormDisconnectionType = OverflowFormDisconnectionType.CHANGE_CARD_POSITION_EXIT;
      this.registerOperation(OverflowFormStatus.INACTIVE, false);
      this.gameFormIndex = index;
      return;
    }

    // 位置没有变化时，游戏卡片保持暂停态，场景动效卡片中，长时激活卡片恢复为激活态，普通互动卡片停止溢出，进入非激活态
    if (!this.isFunInteraction && (this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent).isLongActiveForm()) {
      this.resumeActive(true);
    } else {
      this.stopOverflow(this.isFunInteraction);
    }
    this.updateOverflowFormIndex();
  }

  /**
   * 非用户当前操作的卡片，统一进入非激活态
   */
  private onActiveFormChanged(): void {
    if (this.activeForm?.cardId === this.mFormItem.cardId ||
      this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.INACTIVE) {
      log.showInfo('onActiveFormChanged: is not alive form');
      return;
    }

    // 当前卡片是 sceneAnimation 且没有发起 requestOverflow 接口，卡片没有溢出，不处理
    // 当前卡片是长时激活卡片，取消溢出
    if (!this.isFunInteraction) {
      let event: OverflowSceneAnimationFormEvent = this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent;
      if (!event.isRequestOverflow()) {
        return;
      }
      if (event.isLongActiveForm()) {
        this.stopOverflow(this.getPageIndex() === this.getIndexInSwiper())
        return;
      }
    }

    // activeForm 是 funInteraction 卡片，统一进入非激活
    let isAliveFormFunInteraction: boolean =
      this.activeForm?.gameCardInfo?.extensionType === OverflowConstants.INTERACTION_TYPE ||
      this.activeForm?.gameCardInfo?.gameType === OverflowConstants.QUICK_TYPE_GAMECARD;
    if (isAliveFormFunInteraction) {
      this.mOverflowFormVm.overflowFormDisconnectionType =
        this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.ACTIVE ?
        OverflowFormDisconnectionType.ACTIVE_OTHER_GAME_IN_ACTIVE_STATUS :
        OverflowFormDisconnectionType.ACTIVE_OTHER_GAME_IN_PAUSE_STATUS
      this.registerOperation(OverflowFormStatus.INACTIVE, this.getPageIndex() === this.getIndexInSwiper());
      return;
    }

    // activeForm 是 sceneAnimation 卡片或者 activeForm 是空
    // 1. 当前卡片是 funInteraction，且处于激活态，切换到暂停态；其他状态保持不变
    if (this.isFunInteraction) {
      if (this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.ACTIVE) {
        this.stopActive(this.getPageIndex() === this.getIndexInSwiper());
      }
      return;
    }

    // 2. 当前卡片是 sceneAnimation 且正在发起 requestOverflow 接口，进入非激活态
    let event: OverflowSceneAnimationFormEvent = this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent;
    if (event.isRequestOverflow()) {
      this.mOverflowFormVm.overflowFormDisconnectionType = OverflowFormDisconnectionType.OTHER_CARD_OVERFLOW_EXIT;
      let hadAnimation: boolean = (this.isSystemApp || !event.useDefaultAnimation()) ?
        false : this.getPageIndex() === this.getIndexInSwiper()
      this.stopOverflow(hadAnimation);
      return;
    }
  }

  private canUpdateStatusChange(): void {
    if (!this.canUpdateStatus) {
      return;
    }
    log.showInfo('canUpdateStatusChange, start update status');
    if (this.mOverflowFormItemEvent) {
      this.mOverflowFormStatusController?.updateStatus(this.mOverflowFormItemEvent, this.mOverflowFormVm,
        this.uiExtProxy);
    }
  }

  private setCanUpdateStatus(value: boolean): void {
    this.canUpdateStatus = value;
  }

  private getCanUpdateStatus(): boolean {
    return this.canUpdateStatus;
  }

  private handleDesktopLoseFocus(): void {
    if (!this.mOverflowFormVm) {
      log.showError(`handleDesktopLoseFocus, mOverflowFormVm is undefined, formId:${this.mFormItem.cardId}`);
      return;
    }
    if (this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.INACTIVE) {
      return;
    }
    this.mOverflowFormVm.overflowFormDisconnectionType = OverflowFormDisconnectionType.DESKTOP_LOSE_FOCUS_EXIT;
    this.stopActive(false);
  }

  private registerOperation(targetStatus: OverflowFormStatus, hasAnimation: boolean): void {
    if (!this.mOverflowFormItemEvent) {
      log.showInfo('registerOperation, overflowFormItemEvent is not ready');
      return;
    }
    this.mOverflowFormStatusController?.registerOperation(this.mOverflowFormItemEvent, targetStatus, hasAnimation,
      this.mOverflowFormVm, this.uiExtProxy);
  }

  aboutToAppear(): void {
    log.showInfo('OverflowFormItem aboutToAppear');
    this.init();

    try {
      let status: string = systemParameterEnhance.getSync('persist.phone_focus.advance.mode.status');
    } catch(err) {
      log.showError('systemParameterEnhance getSync failed');
    }
  }

  aboutToDisappear(): void {
    log.showInfo('OverflowFormItem aboutToDisappear');
    OverflowFormUtils.setActiveFormTouch(false);
    if (!this.isFunInteraction) {
      this.mOverflowViewModel.removeKeyFromOverflowLinkedList(this.mFormItem.cardId);
      (this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent).release();
    }
    this.mOverflowFormStatusController?.release();
    this.clearStartOverflowFormTimeout();
    if (this.timeId !== UNDEFINED_TIME_ID) {
      clearTimeout(this.timeId);
      this.timeId = UNDEFINED_TIME_ID;
    }
  }
  private clearStartOverflowFormTimeout(): void {
    if (this.startOverflowFormTimeout) {
      clearTimeout(this.startOverflowFormTimeout);
      this.startOverflowFormTimeout = undefined;
    }
  }

  private initOverflowFormIconConfig(): void {
    switch (this.mFormItem.cardDimension) {
      case CommonConstants.CARD_DIMENSION_1x2:
        this.mOverflowFormIconConfig = OVERFLOW_FORM_ICON_CONFIG['small'];
        break;
      case CommonConstants.CARD_DIMENSION_2x2:
        this.mOverflowFormIconConfig = OVERFLOW_FORM_ICON_CONFIG['medium'];
        break;
      case CommonConstants.CARD_DIMENSION_2x4:
      case CommonConstants.CARD_DIMENSION_4x4:
      case CommonConstants.CARD_DIMENSION_6x4:
        this.mOverflowFormIconConfig = OVERFLOW_FORM_ICON_CONFIG['large'];
        break;
      default:
        this.mOverflowFormIconConfig = OVERFLOW_FORM_ICON_CONFIG['medium'];
        break;
    }
  }

  private init() {
    this.isSystemApp = OverflowFormUtils.isSystemApp(this.mFormItem.bundleName);
    this.mFolderStatus = (AppStorage.get('folderStatus') ?? DeviceState.DEFAULT_STATE) as number;
    this.isFunInteraction = this.mFormItem.gameCardInfo?.extensionType === OverflowConstants.INTERACTION_TYPE ||
      this.mFormItem.gameCardInfo?.gameType === OverflowConstants.QUICK_TYPE_GAMECARD;
    this.initOverflowFormIconConfig();
    this.initOverflowFormStatusController();
    this.initOverflowItemEvent();
    this.initUiExtComponentProperties();
    this.updateOverflowFormIndex();
    this.updateBorderRadius();
    log.showInfo('aboutToAppear: formSize: (%{public}d, %{public}d), hotAreaSize: (%{public}d, %{public}d)' +
      ', gameFormIndex: %{public}d', this.screenWidth, this.screenHeight,
      this.mOverflowFormVm.overflowFormHotAreaOffsetX, this.mOverflowFormVm.overflowFormHotAreaOffsetY,
      this.gameFormIndex);
  }

  private initOverflowItemEvent() {
    if (this.mOverflowFormItemEvent) {
      this.mOverflowFormItemEvent.updateOverflowFormConfig(this.mOverflowFormVm, this.mFormComponentBuilderId,
        this.getUIContext(), this.getOverflowFormId(), this.mFormRelativeItemId,
        this.mOverflowFormStatusController, this.uiExtProxy);
      this.mOverflowFormItemEvent.loadExtWant(this.mFormItemWidth, this.mFormItemHeight,
        this.mFormBorderRadius);
      this.mOverflowFormItemEvent.handleTouchEvent = (event: TouchEvent, itemId: string) => {
        this.handleTouchEvent(event, itemId);
      }
      if (this.isFunInteraction) {
        return;
      }
      let event: OverflowSceneAnimationFormEvent = this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent;
      event.initOverflowControllerFunction();
      event.initOverflowSnapshotFunction(
        (formImage: image.PixelMap) => this.setOverflowSnapshot(formImage),
        () => this.releaseOverflowSnapshot());
      if (event.useDefaultAnimation()) {
        return;
      }
      log.showInfo(`aboutToAppear: dragSnapshot is empty: ${CheckEmptyUtils.isEmpty(this.dragSnapshot)}`);
      if (CheckEmptyUtils.isEmpty(this.dragSnapshot)) {
        return;
      }
      this.extComponentContent = new ComponentContent(this.getUIContext(),
        wrapBuilder(extensionPlaceholder),
        new ExtensionPlaceholderParams(this.dragSnapshot!, this.mFormItemWidth, this.mFormItemHeight,
          this.mFormBorderRadius));
    }
  }

  private initSceneAnimationOverflowUiExtComponentProperties(): void {
    let event: OverflowSceneAnimationFormEvent = this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent;
    let overflowInfo: formInfo.OverflowInfo = event.getOverflowInfo() as formInfo.OverflowInfo;
    event.updateExtensionComponentToOverflow(overflowInfo);
    log.showInfo('uiExtensionComponent size: [%{public}d, %{public}d]' +
      ', uiExtensionComponentOffset: [%{public}d, %{public}d], overflowFormHotAreaOffset: [%{public}d, %{public}d]',
      this.mOverflowFormVm.uiExtensionComponentWidth, this.mOverflowFormVm.uiExtensionComponentHeight,
      this.mOverflowFormVm.uiExtensionComponentOffsetX, this.mOverflowFormVm.uiExtensionComponentOffsetY,
      this.mOverflowFormVm.overflowFormHotAreaOffsetX, this.mOverflowFormVm.overflowFormHotAreaOffsetY);
  }

  private initFunInteractionUiExtComponentProperties(): void {
    this.mOverflowFormVm.uiExtensionComponentWidth = this.screenWidth;
    this.mOverflowFormVm.uiExtensionComponentHeight = this.screenHeight;
    this.mOverflowFormVm.uiExtensionComponentOffsetX = 0;
    this.mOverflowFormVm.uiExtensionComponentOffsetY = 0;
    this.mOverflowFormVm.overflowFormHotAreaOffsetX =
      (this.mOverflowFormVm.uiExtensionComponentWidth - this.mFormItemWidth) / NumberConstants.CONSTANT_NUMBER_TWO;
    this.mOverflowFormVm.overflowFormHotAreaOffsetY =
      (this.mOverflowFormVm.uiExtensionComponentHeight - this.mFormItemHeight) / NumberConstants.CONSTANT_NUMBER_TWO;
  }

  private initDefaultUiExtComponentProperties(): void {
    let event: OverflowSceneAnimationFormEvent = this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent;
    event.setDefaultUiExtComponentProperties();
  }

  private initUiExtComponentProperties(): void {
    if (this.isFunInteraction) {
      this.initFunInteractionUiExtComponentProperties();
      return;
    }
    if (!this.mOverflowFormItemEvent) {
      this.initDefaultUiExtComponentProperties();
      return;
    }
    let event: OverflowSceneAnimationFormEvent = this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent;
    if (event.getOverflowInfo() !== undefined && event.isRequestOverflow()) {
      this.initSceneAnimationOverflowUiExtComponentProperties();
      return;
    }
    this.initDefaultUiExtComponentProperties();
  }

  private initOverflowFormStatusController(): void {
    if (this.isFunInteraction) {
      this.mOverflowFormStatusController = new OverflowFunInteractionFormStatusController(this.mFormItem.cardId,
        this.mFormItem.gameCardInfo?.pauseDuration);
    } else {
      this.mOverflowFormStatusController = new OverflowSceneAnimationFormStatusController(this.mFormItem.cardId);
    }
    this.mOverflowFormStatusController.initFunction(
      (value: boolean) => this.setCanUpdateStatus(value),
      (): boolean => this.getCanUpdateStatus(),
      (): boolean => this.isReadyChangeActive(),);
  }

  private handleTouchEvent(event: TouchEvent, itemId: string): void {
    log.showInfo(`handleTouchEvent: formId: ${this.mFormItem.cardId}`);

    if (this.mOverflowFormItemEvent) {
      this.mOverflowFormItemEvent.removeHoverEffect();
      this.mOverflowFormItemEvent.onTouchEventHandler(event, itemId, this.isInDrag);
      this.handleOverflowFormTouchEvent(event);
    }
  }

  private handleOverflowFormTouchEvent(event: TouchEvent): void {
    if (this.mOverflowFormVm && !this.isFormActive()) {
      return;
    }
    if (event.type !== TouchType.Down && event.type !== TouchType.Up && event.type !== TouchType.Cancel) {
      return;
    }

    if (event.type === CommonConstants.TOUCH_TYPE_DOWN) {
      OverflowFormUtils.setActiveFormTouch(true);
      log.showInfo('set isActiveFormTouchStatus = true');
      return;
    }
    log.showInfo('set isActiveFormTouchStatus = false');
    this.clearOverflowFormActiveTouchTimer();
    this.mActiveFormTouchTimer = setTimeout(() => {
      OverflowFormUtils.setActiveFormTouch(false);
    }, OVERFLOW_PANGESTURE_TIMER);
  }

  private clearOverflowFormActiveTouchTimer(): void {
    if (this.mActiveFormTouchTimer) {
      clearTimeout(this.mActiveFormTouchTimer);
    }
    this.mActiveFormTouchTimer = undefined;
  }

  private getOverflowFormId(): string {
    return `${this.mFormItem.cardId}_UIExtensionComponent`;
  }

  private handleActiveOverflowFormTouchEvent(event: TouchEvent): void {
    if (!event) {
      log.showError('handleActiveOverflowFormTouchEvent TouchEvent is empty');
      return;
    }
    // 记录用户交互
    if (event.type === TouchType.Up) {
      log.showInfo(`TouchUp live form: ${this.mFormItem.cardId}`);
      LiveFormSupportMgr.getInstance().addSupportLauncher(this.mFormItem.cardId);

      if (this.timeId !== UNDEFINED_TIME_ID) {
        log.showWarn('repeated TouchUp live form');
        return;
      }
      this.timeId = setTimeout(() => {
        LiveFormSupportMgr.getInstance().removeSupportLauncher(this.mFormItem.cardId);
        this.timeId = UNDEFINED_TIME_ID;
      }, LIVE_FORM_CLICK_TIMEOUT_MS);
    }

    if (!this.mOverflowFormStatusController || !this.mOverflowFormItemEvent) {
      log.error(`mOverflowFormStatusController or mOverflowFormItemEvent is undefined`);
      return;
    }
    if (!this.isFormActive()) {
      return;
    }
    if (event.type === TouchType.Down) {
      this.mOverflowFormStatusController.clearOverflowFormActiveTimer();
      if (!this.isFunInteraction) {
        (this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent).updateConnectionInfo();
      }
      return;
    }
    if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      if (this.isFunInteraction) {
        (this.mOverflowFormStatusController as
          OverflowFunInteractionFormStatusController)?.updateOverflowFormActiveTimer(
          (this.mOverflowFormItemEvent as OverflowFunInteractionFormEvent), this.mOverflowFormVm);
      }
    }
  }

  private getPageIndex(): number {
    if (this.isOuterDesktop) {
      return this.outerPageIndex;
    }
    return this.pageIndex;
  }

  private isFormActive() {
    return this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.ACTIVE
  }

  private activeFormWhenReceiveMsgFromRemote(data: Record<string, Object>) {
    log.showInfo(`onReceive, bundleName = ${this.mFormItem.bundleName}, isSystemApp:${this.isSystemApp}`);
    if (!this.isSystemApp) {
      return;
    }
    log.showInfo(`onReceive, isFormReady = ${data['isFormReady'] as boolean}`)
    let isFormReady: boolean = data['isFormReady'] as boolean;
    if (isFormReady && this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.INACTIVE) {
      // UIExtension ready后，再将组件show出
      this.registerOperation(OverflowFormStatus.ACTIVE, false);
      return;
    }
    let isExtensionOverflowReady = data['isExtensionOverflowReady'] as boolean;
    log.showInfo(`onReceive, isExtensionOverflowReady = ${isExtensionOverflowReady}`)
    if (isExtensionOverflowReady) {
      this.startShowLongActiveFormOverflow();
      return;
    }
  }

  private startShowLongActiveFormOverflow(): void {
    if (this.isFunInteraction) {
      return;
    }
    let event: OverflowSceneAnimationFormEvent = this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent;
    if (!event.isLongActiveForm() || !this.isFormActive()) {
      log.showInfo(`startShowLongActiveFormOverflow, is not long active, formId: ${this.mFormItem.cardId}`);
      return;
    }
    log.showInfo(`startShowLongActiveFormOverflow formId: ${this.mFormItem.cardId}`);
    event.startShowLongActiveFormOverflow();
  }

  private handleSnapshotUpdate(): void {
    if (this.isFunInteraction) {
      return;
    }
    let event: OverflowSceneAnimationFormEvent = this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent;
    if (!event.isLongActiveForm() || !this.isFormActive()) {
      log.showInfo('image onComplete, is not long active, formId: %{public}s', this.mFormItem.cardId);
      return;
    }
    if (event.isInBackground()) {
      event.afterStopLongActiveFormActive();
      return;
    }
    if (!event.isRequestOverflow() && event.getOverflowInfo()) {
      event.afterStartLongActiveFormOverflow(event.getOverflowInfo());
    }
  }

  build() {
    Stack() {
      Stack() {
        if (this.isFunInteraction) {
          this.OverflowPauseBuilder();
        }
        if (this.isFunInteraction) {
          this.FunInteractionOverflowFormBuilder();
        } else {
          this.SceneAnimationOverflowFormBuilder();
          Image(this.overflowSnapshot)
            .opacity(this.mOverflowFormVm.imageOpacity)
            .hitTestBehavior(HitTestMode.None)
            .onComplete((event) => {
              if (!event) {
                return;
              }
              log.showInfo(`image onComplete, formId: ${this.mFormItem.cardId}, loadingStatus: ${event.loadingStatus}`);
              if (event.loadingStatus === IMAGE_DECODED_FINISH) {
                this.handleSnapshotUpdate();
              }
            })
            .onError((error) => {
              log.showError(`image onError, formId: ${this.mFormItem.cardId}, message: ${error?.message}`);
            })
            .width(this.mFormItemWidth)
            .height(this.mFormItemHeight)
            .borderRadius(this.mFormBorderRadius)
        }
        if (this.isFunInteraction) {
          this.OverflowPauseIconBuilder();
        }
      }
    }
    .responseRegion([{
      x: DEFAULT_POSTION_X,
      y: DEFAULT_POSTION_Y,
      width: EditModeUtils.convertWithDesktopScale(this.mFormItemWidth) * this.scaleX,
      height: EditModeUtils.convertWithDesktopScale(this.mFormItemHeight +
        OVERFLOW_FORM_HOT_AREA_EXTEND) * this.scaleY,
    }])
    .onTouch((event: TouchEvent): void => {
      this.handleActiveOverflowFormTouchEvent(event);
    })

    // 当执行应用启动退出动效时候，不响应
    .enabled(!this.isDuringStartExitAnimation)
  }

  @Builder
  OverflowPauseIconBuilder() {
    Button({ type: ButtonType.Circle, stateEffect: false }) {
      Image($r('app.media.overflow_form_pause'))
        .width(this.mOverflowFormIconConfig.pauseIconSize)
        .height(this.mOverflowFormIconConfig.pauseIconSize)
        .draggable(false)
        .interpolation(ImageInterpolation.Low)
        .matchTextDirection(true)
        .autoResize(false)
    }
    .width(this.mOverflowFormIconConfig.pauseIconSize)
    .height(this.mOverflowFormIconConfig.pauseIconSize)
    .backgroundColor(Color.Transparent)
    .draggable(false)
    .onClick(() => {
      this.stopActive(true);
    })
    .accessibilityDescription(this.isAccessibilityMode ?
      `${ResourceManager.getInstance().getStringByName('pause_extension')},` +
      `${ResourceManager.getInstance().getStringByName('double_tap_to_execute')}` : '')
    .visibility(this.mOverflowFormVm.overflowFormStatus === OverflowFormStatus.ACTIVE ?
                Visibility.Visible : Visibility.Hidden)
    .position(I18n.isRTL(I18n.System.getSystemLanguage()) ?
      {x: this.mOverflowFormIconConfig.pauseIconPadding,
       y: this.mFormItem.cardDimension === CommonConstants.CARD_DIMENSION_1x2 ?
         (this.mFormItemHeight - this.mOverflowFormIconConfig.pauseIconSize) / NumberConstants.CONSTANT_NUMBER_TWO :
          this.mOverflowFormIconConfig.pauseIconPadding} :
      {x: this.mFormItemWidth - this.mOverflowFormIconConfig.pauseIconSize -
          this.mOverflowFormIconConfig.pauseIconPadding,
       y: this.mFormItem.cardDimension === CommonConstants.CARD_DIMENSION_1x2 ?
         (this.mFormItemHeight - this.mOverflowFormIconConfig.pauseIconSize) / NumberConstants.CONSTANT_NUMBER_TWO :
          this.mOverflowFormIconConfig.pauseIconPadding})
    .priorityGesture(GestureGroup(GestureMode.Parallel,
      PanGesture(new PanGestureOptions({
        distance: PAN_GESTURE_MIN_DISTANCE,
        direction: PanDirection.Right
      })),
      PanGesture(new PanGestureOptions({
        distance: PAN_GESTURE_MIN_DISTANCE,
        direction: PanDirection.Left
      }))
    ))
  }

  @Builder
  OverflowPauseBuilder() {
    Row({ space: this.mOverflowFormIconConfig.iconSpace }) {
      // 暂停态恢复激活态蒙层
      Button({ type: ButtonType.Circle, stateEffect: false }) {
        Image($r('app.media.overflow_form_resume'))
          .width(this.mOverflowFormIconConfig.iconSize)
          .height(this.mOverflowFormIconConfig.iconSize)
          .draggable(false)
          .interpolation(ImageInterpolation.Low)
          .matchTextDirection(true)
          .autoResize(false)
      }
      .width(this.mOverflowFormIconConfig.iconSize)
      .height(this.mOverflowFormIconConfig.iconSize)
      .backgroundColor(Color.Transparent)
      .draggable(false)
      .onClick(() => {
        if (this.isFunInteraction) {
          (this.mOverflowFormItemEvent as OverflowFunInteractionFormEvent).getOverflowFormResumeTime();
        }
        this.registerOperation(OverflowFormStatus.ACTIVE, true);
      })
      .accessibilityDescription(this.isAccessibilityMode ?
        `${ResourceManager.getInstance().getStringByName('resume_extension')},` +
        `${ResourceManager.getInstance().getStringByName('double_tap_to_execute')}` : '')
      .visibility(!this.mOverflowFormVm.isInLongPress ? Visibility.Visible : Visibility.Hidden)

      // 结束游戏，暂停态进入非激活态蒙层
      Button({ type: ButtonType.Circle, stateEffect: false }) {
        Image($r('app.media.overflow_form_over'))
          .width(this.mOverflowFormIconConfig.iconSize)
          .height(this.mOverflowFormIconConfig.iconSize)
          .draggable(false)
          .interpolation(ImageInterpolation.Low)
          .matchTextDirection(true)
          .autoResize(false)
      }
      .width(this.mOverflowFormIconConfig.iconSize)
      .height(this.mOverflowFormIconConfig.iconSize)
      .backgroundColor(Color.Transparent)
      .draggable(false)
      .onClick(() => {
        this.mOverflowFormVm.overflowFormDisconnectionType = OverflowFormDisconnectionType.CONSUMER_QUIT;
        this.registerOperation(OverflowFormStatus.INACTIVE, true);
      })
      .accessibilityDescription(this.isAccessibilityMode ?
        `${ResourceManager.getInstance().getStringByName('disconn_extension')},` +
          `${ResourceManager.getInstance().getStringByName('double_tap_to_execute')}` : '')
      .visibility(!this.mOverflowFormVm.isInLongPress ? Visibility.Visible : Visibility.Hidden)
    }

    // 只有当桌面处于正常模式下，才支持点击
    .enabled(this.isNormalDesktopMode)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .draggable(false)
    .width(this.mFormItemWidth)
    .height(this.mFormItemHeight)
    .borderRadius(this.mFormBorderRadius)
    .renderGroup(this.mOverflowFormVm?.isControlButtonInRenderGroup)

    // 拖拽动作过程中，暂停态蒙层不显示
    .visibility(this.mFormComponentVm.mFormVisible && !this.isInDrag ?
      this.mOverflowFormVm.overflowPauseVisibilityStatus : Visibility.Hidden)
    .accessibilityLevel(this.isAccessibilityMode ? 'yes' : 'auto')
  }

  @Builder
  FunInteractionOverflowFormBuilder() {
    UIExtensionComponent(
      this.mOverflowFormVm.uiExtWant,
      { dpiFollowStrategy: DpiFollowStrategy.FOLLOW_HOST_DPI }
    )
      .overflowFormEventStyle()
      .funInteractionGestureStyle()
      .responseRegion([{
        x: this.mOverflowFormVm.overflowFormHotAreaOffsetX,
        y: this.mOverflowFormVm.overflowFormHotAreaOffsetY,
        width: EditModeUtils.convertWithDesktopScale(this.mFormItemWidth) * this.scaleX,
        height: EditModeUtils.convertWithDesktopScale(this.mFormItemHeight +
          OVERFLOW_FORM_HOT_AREA_EXTEND) * this.scaleY,
      }])
      .onRemoteReady((proxy: UIExtensionProxy) => {
        this.onRemoteReady(proxy);
        this.mOverflowFormVm.overflowFormConnectionType = OverflowFormConnectionType.USER_CLICK;
      })
      .onReceive((data: Record<string, Object>) => {
        this.onReceive(data);
      })

      // UIExtension 组件断连时，执行卡片销毁
      .onTerminated(() => {
        log.showInfo(`onTerminated, formId: ${this.mFormItem.cardId}, stop overflowForm directly`);
        this.onDisConnect();
      })
      .onError((error: BusinessError) => {
        log.showWarn(`onError, formId: ${this.mFormItem.cardId}, stop overflowForm directly`);
        if (error.code === ERROR_CODE_UIEXTENSION_EXITED_ABNORMALLY) {
          this.mOverflowFormVm.overflowFormDisconnectionType = OverflowFormDisconnectionType.ABNORMAL_EXIT;
        }
        this.onDisConnect();
      })
      .onRelease(() => {
        log.showWarn(`onRelease, formId: ${this.mFormItem.cardId}, stop overflowForm directly`);
        this.onDisConnect();
      })
  }

  @Builder
  SceneAnimationOverflowFormBuilder() {
    UIExtensionComponent(
      this.mOverflowFormVm.uiExtWant,
      {
        dpiFollowStrategy: DpiFollowStrategy.FOLLOW_HOST_DPI,
        placeholder: this.extComponentContent
      }
    )
      .opacity(this.mOverflowFormVm.uecOpacity)
      .overflowFormEventStyle()
      .sceneAnimationGestureStyle()
      .offset({
        x: this.mOverflowFormVm.uiExtensionComponentOffsetX,
        y: this.mOverflowFormVm.uiExtensionComponentOffsetY
      })
      .responseRegion([{
        x: this.mOverflowFormVm.overflowFormHotAreaOffsetX,
        y: this.mOverflowFormVm.overflowFormHotAreaOffsetY,
        width: EditModeUtils.convertWithDesktopScale(this.mFormItemWidth) * this.scaleX,
        height: EditModeUtils.convertWithDesktopScale(this.mFormItemHeight) * this.scaleY,
      }])
      .onRemoteReady((proxy: UIExtensionProxy) => {
        let requestForm: ConnectionInfo | undefined =
          AppStorage.get<ConnectionInfo>(OverflowConstants.CONNECTION_INFO);
        let userEditFormId: string | undefined = AppStorage.get<string>('userEditFormId');
        if (requestForm?.formId === this.mFormItem.cardId) {
          this.mOverflowFormVm.overflowFormConnectionType = OverflowFormConnectionType.USER_CLICK;
        } else if (userEditFormId === this.mFormItem.cardId) {
          this.mOverflowFormVm.overflowFormConnectionType = OverflowFormConnectionType.EDIT_FORM_REFRESH;
        }
        this.onRemoteReadyOfSceneAnimation(proxy);
        if (this.mOverflowFormItemEvent) {
          this.mOverflowFormItemEvent.recordLaunchOverflowCardInfo();
        }
      })
      .onReceive((data: Record<string, Object>) => {
        this.activeFormWhenReceiveMsgFromRemote(data);
      })

        // UIExtension 组件断连时，执行卡片销毁
      .onTerminated(() => {
        log.showInfo(`onTerminated, formId: ${this.mFormItem.cardId}, stop overflowForm directly`);
        this.onDisConnect();
      })
      .onError((error: BusinessError) => {
        log.showError(`onError, formId: ${this.mFormItem.cardId}, stop overflowForm directly`);
        if (error.code === ERROR_CODE_UIEXTENSION_EXITED_ABNORMALLY) {
          this.mOverflowFormVm.overflowFormDisconnectionType = OverflowFormDisconnectionType.ABNORMAL_EXIT;
        }
        this.onDisConnect();
      })
      .onRelease(() => {
        log.showWarn(`onRelease, formId: ${this.mFormItem.cardId}, stop overflowForm directly`);
        this.onDisConnect();
      })
  }
  @Styles
  sceneAnimationGestureStyle() {
    .priorityGesture(GestureGroup(GestureMode.Parallel,
      // 阻塞外部单击手势 onClick desktop 响应
      TapGesture({ count: CommonConstants.GESTURE_SINGLE_CLICK }),
      PanGesture(new PanGestureOptions({
        distance: PAN_GESTURE_MIN_DISTANCE,
        direction: OverflowFormUtils.isBehaviorDisabled(DisableGesture.SWIPE_DESKTOP,
          this.mFormItem as Object as GridLayoutItemInfo) ? PanDirection.Right : PanDirection.None
      })),
      PanGesture(new PanGestureOptions({
        distance: PAN_GESTURE_MIN_DISTANCE,
        direction: OverflowFormUtils.isBehaviorDisabled(DisableGesture.SWIPE_DESKTOP,
          this.mFormItem as Object as GridLayoutItemInfo) ? PanDirection.Left : PanDirection.None
      }))
    ))
  }

  @Styles
  funInteractionGestureStyle() {
    .priorityGesture(GestureGroup(GestureMode.Parallel,
      // 阻塞外部单击手势 onClick desktop 响应
      TapGesture({ count: CommonConstants.GESTURE_SINGLE_CLICK }),
      PanGesture(new PanGestureOptions({
        distance: PAN_GESTURE_MIN_DISTANCE,
        direction: PanDirection.Right
      })),
      PanGesture(new PanGestureOptions({
        distance: PAN_GESTURE_MIN_DISTANCE,
        direction: PanDirection.Left
      }))
    ))
  }

  @Styles
  overflowFormEventStyle() {
    .id(this.getOverflowFormId())
    .width(this.mOverflowFormVm.uiExtensionComponentWidth)
    .height(this.mOverflowFormVm.uiExtensionComponentHeight)
    .visibility(this.isInDrag ? Visibility.Hidden : this.mOverflowFormVm.overflowFormVisibilityStatus)
    .accessibilityLevel('no-hide-descendants')
    .onFocus(() => {
      log.showInfo(`onFocus: ${this.mFormItem.cardId}`);
      if (!this.isFunInteraction) {
        return;
      }

      this.isInScreenSnapshot = false;
      if (this.mOverflowFormItemEvent) {
        (
          this.mOverflowFormStatusController as OverflowFunInteractionFormStatusController
        )?.updateOverflowFormActiveTimer(
          (this.mOverflowFormItemEvent as OverflowFunInteractionFormEvent), this.mOverflowFormVm);
      }
    })
    .onBlur(() => {
      log.showInfo(`onBlur: ${this.mFormItem.cardId}`);
      if (!this.isFunInteraction) {
        return;
      }

      // 只处理激活态失焦
      if (!this.isFormActive()) {
        return;
      }

      // 激活态执行失去焦点动效切换状态场景：
      // 1.拖动其他组件失去焦点
      if (this.isDrag) {
        return;
      }
      this.stopActive(false);
    })
  }

  private onRemoteReady(proxy: UIExtensionProxy) {
    this.uiExtProxy = proxy;
    log.showInfo(`onRemoteReady: formId: ${this.mFormItem.cardId}`);
    if (this.mOverflowFormItemEvent) {
      this.mOverflowFormItemEvent.getOverflowFormActiveTime();
    }

    // UIExtension ready后，再将组件show出
    this.registerOperation(OverflowFormStatus.ACTIVE, true);
  }

  private onRemoteReadyOfSceneAnimation(proxy: UIExtensionProxy) {
    this.uiExtProxy = proxy;
    (this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent).setProxy(proxy);
    log.showInfo(`onRemoteReadyOfSceneAnimation: formId: ${this.mFormItem.cardId}`);
    if (this.mOverflowFormItemEvent) {
      this.mOverflowFormItemEvent.getOverflowFormActiveTime();
    }
    // UIExtension ready后，再将组件show出
    log.showInfo(`onRemoteReadyOfSceneAnimation, bundleName = ${this.mFormItem.bundleName},
      isSystemApp:${this.isSystemApp}`)
    if (this.isSystemApp) {
      return;
    }
    let useDefaultAnimation: boolean =
      (this.mOverflowFormItemEvent as OverflowSceneAnimationFormEvent).useDefaultAnimation();
    let hasSnapshot: boolean = this.dragSnapshot !== undefined;
    log.showInfo(`onRemoteReadyOfSceneAnimation useDefaultAnimation : ${useDefaultAnimation},
      is snapshot succed: ${hasSnapshot}`);
    let hasAnimation: boolean = useDefaultAnimation || !hasSnapshot;
    if (!hasAnimation) {
      this.clearStartOverflowFormTimeout();
      this.startOverflowFormTimeout = setTimeout(() => {
        this.registerOperation(OverflowFormStatus.ACTIVE, hasAnimation);
      }, NumberConstants.CONSTANT_NUMBER_250);
    } else {
      this.registerOperation(OverflowFormStatus.ACTIVE, hasAnimation);
    }
  }

  private onReceive(data: Record<string, Object>) {
    if (data && typeof data['frameReady'] === 'string' && data['frameReady'] === '') {
      if (this.mOverflowFormItemEvent) {
        this.mOverflowFormItemEvent.recordLaunchOverflowCardInfo();
      }
    }
  }

  private onDisConnect(): void {
    this.uiExtProxy = null;
    this.registerOperation(OverflowFormStatus.INACTIVE, false);
    this.mOverflowViewModel.removeKeyFromOverflowLinkedList(this.mFormItem.cardId);
  }
}
