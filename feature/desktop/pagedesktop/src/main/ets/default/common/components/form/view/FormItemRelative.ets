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
import { formHost } from '@kit.FormKit';
import { image } from '@kit.ImageKit';
import { formInfo } from '@kit.FormKit';
import componentSnapshot from '@ohos.arkui.componentSnapshot';
import { BuilderNode } from '@kit.ArkUI';
import {
  CheckEmptyUtils,
  OutdoorConfig,
  LogDomain,
  LogHelper,
  PixelMapUtil,
  SingleContext
} from '@ohos/basicutils';
import {
  DeviceHelper,
  GlobalContext,
  HiSysEventUtil,
  ResourceManager,
  localEventManager,
  ViewCallback,
  viewMgrPolicy,
  ViewType,
  LightOutdoorConfig
} from '@ohos/frameworkwrapper';
import { launcherStatusUtil, ResUtils } from '@ohos/windowscene';
import { NumberConstants, SCBConstants } from '@ohos/commonconstants';
import {
  FormConstants, FormStyleConfig, FormViewModel
} from '@ohos/form';
import {
  AppName,
  DeskTopItemStyle,
  FormComponentEvent,
  FormComponentModel,
  FormComponentVm,
  FormBaseComponent,
  MenuCommonUtil,
  PageDesktopOneShotManager,
  CardNodeControllerManager,
  RemoveFormDialog
} from '@ohos/launchercommon/Index';
import {
  CardItemInfo,
  CommonConstants,
  DeviceState,
  EditModeConstants,
  editModeManager,
  EditModeUtils,
  FormCommonUtil,
  GrayAppListManager,
  GridLayoutItemInfo,
  MenuInfo,
  StyleConstants,
  UninstallDialogStatus,
  CloseAppManager,
  EventConstants,
  ReceiveEventInfo,
  LayoutViewModel,
  lockLayoutManager,
  EditModeState,
  FormLocation,
  FormHostService,
  FormModel,
  UninstallListener,
  LiveFormSupportMgr,
  FormRelationManager
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { NoIconAppInfo, NoIconAppModel } from '@ohos/launchercommon/src/main/ets/model/NoIconAppModel';
import FormStyleConstants from '@ohos/form/src/main/ets/default/common/constants/FormStyleConstants';
import { AppNameVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppNameVm';
import { AppNameEvent } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppNameEvent';
import lazy { OverflowConstants } from '@ohos/commonconstants/src/main/ets/constants/SCBConstants';
import { GridLayoutUtil } from '@ohos/launchercommon';
import { RemoveCardResultType } from '@ohos/form/src/main/ets/default/util/FormHiSysEventUtil';
import CardLockManager from '@ohos/launchercommon/src/main/ets/manager/CardLockManager';
import { CardNodeController } from '@ohos/launchercommon/src/main/ets/buildernode/CardNodeController';
import { FormBasicParams } from '@ohos/launchercommon/src/main/ets/manager/CardNodeControllerManager';
import { FormComponentConfig } from '@ohos/launchercommon/src/main/ets/form/model/FormComponentConfig';
import { FormZoomViewManager } from '@ohos/launchercommon/src/main/ets/manager/FormZoomViewManager';
import { PageDesktopViewModel } from '../../../viewmodel/PageDesktopViewModel';
import { FormItemRelativeEvent } from '../viewmodel/FormItemRelativeEvent';
import { FormBackboardVm, FormItemRelativeVm, FormMaskVm, FormAnimateData } from '../viewmodel/FormItemRelativeVm';
import FormBackboard from './FormBackboard';
import FormMask from './FormMask';
import FormMenuItem from './FormMenuItem';
import { FormNameSizeInfo, FormNameVm } from '../viewmodel/FormNameVm';
import { FormNameEvent } from '../viewmodel/FormNameEvent';
import { FormMenuVm } from '../viewmodel/FormMenuVm';
import { FormMenuEvent } from '../viewmodel/FormMenuEvent';
import lazy OverflowFormItem from '../../liveform/view/OverflowFormItem';
import lazy { OverflowFunInteractionFormEvent } from '../../liveform/event/OverflowFunInteractionFormEvent';
import { DesktopAccessibilityUtils } from '../../../DesktopAccessibilityUtils';
import lazy { PcFormComponentEvent } from '../viewmodel/PcFormComponentEvent';
import lazy { OverflowSceneAnimationFormEvent } from '../../liveform/event/OverflowSceneAnimationFormEvent';
import lazy { FormZoomPreviewComponent } from '../../formAdjust/view/FormZoomPreviewComponent';
import { HOT_AREA_HEIGHT, HOT_AREA_WIDTH, INVALID_FORM_ZOOM_ID } from '../../formAdjust/common/FormZoomConstants';
import { FormZoomManager } from '../../formAdjust/common/FormZoomManager';
import { formZoomController } from '../../formAdjust/viewModel/FormZoomController';
import { OverflowViewModel } from '../../liveform/viewmodel/OverflowViewModel';
import FeatureConstants from '../../../constants/FeatureConstants';

const TAG = 'FormItemRelative';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const CLOCK_WEATHER_CARD_NAME: string = 'ClockWeatherCard';
const CLOUD_MODE_TWO: string = '64';
const DELAY_THREE_SECOND: number = 3000;

interface FormZoomSupportInfo {
  cardName: string;
  cardDimension: number;
}

@Component
export default struct FormItemRelative {
  @Prop singleContext?: SingleContext;
  private mFormItem: CardItemInfo = new CardItemInfo();
  @State private mFormItemWidth: number = 0;
  @State private mFormItemHeight: number = 0;
  @State private mFormSizeChange: boolean = false;
  private mFormMarginTop: number = 0;
  private mTag: string = '';
  private getIndexInSwiper: Function = (): number => 0;
  // 组件.id， 拖拽卡片形成堆叠时，底层卡片根据该id定位组件信息
  private mFormRelativeItemId: string = '';
  //FormComponent组件的.id
  private mFormComponentId: string = '';
  //FormComponentBuilder组件的.id
  private mFormComponentBuilderId: string = '';
  private mMenuInfo: MenuInfo[] = [];
  private mIsDesktopItem: boolean = false;
  private mDefaultType: boolean = true;
  private mResourceManager: ResourceManager = ResourceManager.getInstance();
  private mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
  private mOverflowViewModel: OverflowViewModel = OverflowViewModel.getInstance();
  private mFormViewModel: FormViewModel = FormViewModel.getInstance(this.singleContext);
  private mFormStyleConfig: FormStyleConfig = this.mFormViewModel.getFormStyleConfig();
  private mViewModel: FormComponentModel = FormComponentModel.getInstance();
  private mAppNameVm: AppNameVm = new AppNameVm();
  private mAppNameEvent: AppNameEvent = new AppNameEvent(this.mAppNameVm);
  @State setFormOpacity: number = 0;
  private unInstallListener: UninstallListener = {
    uninstallApp: (bundleName: string): void => {
    },
    uninstallAppResult: (bundleName: string, resultCode: number):
      void => this.mFormItemEvent.uninstallAppResultHandler(bundleName, resultCode)
  };
  private mFormNameSizeInfo: FormNameSizeInfo = new FormNameSizeInfo();
  @State mFormName: string = '';
  @State mFormItemVm: FormItemRelativeVm = new FormItemRelativeVm();
  @State mFormBackVm: FormBackboardVm = new FormBackboardVm();
  @State mFormMaskVm: FormMaskVm = new FormMaskVm();
  private mFormItemEvent: FormItemRelativeEvent =
    new FormItemRelativeEvent(this.mFormItemVm, this.mFormBackVm, this.mFormMaskVm);
  @State mFormComponentVm: FormComponentVm = new FormComponentVm();
  private mFormComponentEvent: FormComponentEvent = new FormComponentEvent(this.mFormComponentVm);
  @State mFormNameVm: FormNameVm = new FormNameVm();
  private mFormNameEvent: FormNameEvent = new FormNameEvent(this.mFormNameVm);
  @State mFormMenuVm: FormMenuVm = new FormMenuVm();
  private mFormMenuEvent: FormMenuEvent = new FormMenuEvent(this.mFormMenuVm);
  private isNeedWaitClearCards: boolean = false;
  private clearFormZoomTimeoutId: number = 0;
  // 卡片调整大小组件的ID
  @StorageLink('formZoomId') formZoomId: string = INVALID_FORM_ZOOM_ID;
  // 卡片调整大小组件的截图显示状态
  @StorageLink('showFormZoomSnapshot') showFormZoomSnapshot: boolean = false;
  @State dialogName: Resource = $r('app.string.is_delete_card');
  @State formName: string = '';
  @State isAccessibilityFocus: boolean = true;
  @State editModeState: EditModeState = editModeManager.getEditModeState();
  @Consume translateX: number;
  @Consume translateY: number;
  @State isShowCancelDialog: boolean = false;
  @Consume dragSnapshot?: image.PixelMap;
  @Consume @Watch('updateLocation') isInDrag: boolean;
  @Consume @Watch('isEqualToDragItemChange') isDragStart: boolean;
  @ObjectLink @Watch('updateStyle') desktopStyle: DeskTopItemStyle;
  @StorageLink('desktopAppNameChange') @Watch('onLanguageChange') language: string = '';
  @StorageLink('createFormId') @Watch('onCreateFormHandler') createFormId: string = '';
  @StorageProp('lockReceived') @Watch('onLockReceived') mLockReceived: number = 0;
  @StorageProp('isPortrait') @Watch('onPortraitChange') mIsPortrait: boolean = true;
  @StorageLink('folderStatusMenu') @Watch('folderStatusChange') folderStatus: number = DeviceState.DEFAULT_STATE;
  @StorageLink('themeStyle') @Watch('onThemeChange') themeStyle: string = '';
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @StorageProp('desktopIconChange') @Watch('updateFormSize') desktopIconChange: number = 0;
  @StorageProp('isClearInvalidCardsDone') isClearInvalidCardsDone: boolean = false;
  @StorageProp('formDragStart') isFormCenterDrag: boolean = false;

  private carType: string = FeatureConstants.CARD_TYPE_SECOND;
  private mFormZoomManager: FormZoomManager = FormZoomManager.getInstance();
  private isOuterDesktop: boolean = false;
  private isFunInteraction: boolean = false;
  private isLayoutCenterStyle: boolean = false;
  private needUpdateLocation: boolean = false;
  private shadowStyle: ShadowOptions = {
    radius: StyleConstants.FORM_SHADOW_RADIUS,
    color: StyleConstants.FORM_SHADOW_COLOR,
    offsetY: StyleConstants.FORM_SHADOW_OFFSETY
  }
  private mDeleteOuterCardListener?: ReceiveEventInfo;
  private removeFormDialogController: CustomDialogController | null = null;
  private keyguardCallback: ViewCallback = {
    onShow: (): void => this.removeFormDialogController?.close()
  };

  public registerDeleteOuterCardListener(): void {
    this.mDeleteOuterCardListener = {
      onReceiveEvent: (event: string, params: string): void => {
        log.showInfo(`localEventListener receive event: ${event}, params: ${params}.`);
        if (event === EventConstants.EVENT_REQUEST_OUTER_CARD_DELETE && params === this.mFormItem.cardId) {
          const formAnimateData: FormAnimateData = { cardId: this.mFormItem.cardId, isOpenRemoveFormDialog: true };
          AppStorage.setOrCreate('formAnimateData', formAnimateData);
          this.mFormItemEvent.doRemoveFormAnimate(this.mFormItem.page as number);
        }
      }
    };
    localEventManager.registerEventListener(this.mDeleteOuterCardListener, [
      EventConstants.EVENT_REQUEST_OUTER_CARD_DELETE
    ]);
    log.showInfo('registerDeleteOuterCardListener listener on create');
  }

  private mOuterMenuCloseListener?: ReceiveEventInfo;

  public registerOuterMenuCloseListener(): void {
    this.mOuterMenuCloseListener = {
      onReceiveEvent: (event: string, params: string): void => {
        log.showInfo(`localEventListener receive event: ${event}, params: ${params}.`);
        if (event === EventConstants.EVENT_REQUEST_OUTER_MENU_CLOSE && params === this.mFormItem.cardId) {
          this.mFormComponentVm.mFormVisible = true;
        }
      }
    };
    localEventManager.registerEventListener(this.mOuterMenuCloseListener, [
      EventConstants.EVENT_REQUEST_OUTER_MENU_CLOSE
    ]);
    log.showInfo('registerOuterMenuCloseListener listener on create');
  }

  private folderStatusChange(): void {
    if (!launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop)) {
      return;
    }
    if (this.mFormMenuVm.mIsMenuShow) {
      this.mFormMenuVm.mIsHiddenEffect = true;
    }
    this.updateFormSize();
  }

  private onThemeChange(): void {
    if (!launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop)) {
      return;
    }
    let formRadiusFromConfig: number = this.mFormStyleConfig.getFormBorderRadius(this.mFormItem.cardDimension);
    if (formRadiusFromConfig !== CommonConstants.INVALID_VALUE) {
      this.mFormItemVm.mFormBorderRadius = formRadiusFromConfig;
    }
    log.showWarn(`theme change, form[${this.mFormItem.cardId}] new radius: ${formRadiusFromConfig}.`);
    this.updateNode();
  }

  private updateNode(): void {
    const controller = CardNodeControllerManager.getCardController(this.mFormItem.cardId) as CardNodeController;
    if (controller) {
      // 调整cardNode的尺寸
      const params = controller.formParams as FormBasicParams;
      const mFormComponentConfig: FormComponentConfig = FormComponentConfig.getInstance();
      const mFormComponentStyle = mFormComponentConfig.getFormComponentDisplayStyle(this.mFormItem.cardDimension,
        { width: this.mFormItemWidth, height: this.mFormItemHeight });
      params.basicData.width =
        this.isOuterDesktop ? mFormComponentStyle?.formLayoutSize?.width as number : this.mFormItemWidth;
      params.basicData.height =
        this.isOuterDesktop ? mFormComponentStyle?.formLayoutSize?.height as number : this.mFormItemHeight;
      params.basicData.borderRadius = this.mFormItemVm.mFormBorderRadius;
      CardNodeControllerManager.getCardNode(this.mFormItem.cardId)?.update(params);
    }
  }

  private onPortraitChange(): void {
    // 应框架要求，由于卡片使用逐帧动效造成转屏帧率掉帧，转屏场景不使用统一动效，仅卡片可见时加动效
    this.updateFormSize(!FormHostService.getInstance().queryInvisibleListItem(this.mFormItem.cardId));
    this.mFormZoomManager.reset();
  }

  // 获取天气定制1x4卡片高度
  private getDimension1x4Height(): number {
    let padding: number = AppStorage.get<number>('itemPadding') ?? 0;
    let gridHeight: number = GridLayoutUtil.getGridHeight();
    log.showWarn(`dimension 1x4 itemHeight: ${gridHeight} padding: ${padding}`);
    return gridHeight - padding * 2;
  }

  private setFormSize(): void {
    if (this.isOuterDesktop) {
      this.mFormItemWidth = Number(this.mFormStyleConfig.mOuterFormWidth.get(this.mFormItem.cardDimension.toString()));
      this.mFormItemHeight =
        Number(this.mFormStyleConfig.mOuterFormHeight.get(this.mFormItem.cardDimension.toString()));
    } else {
      this.mFormItemWidth = Number(this.mFormStyleConfig.mFormWidth.get(this.mFormItem.cardDimension.toString()));
      if (this.mFormItem.isFormDimension1x4) {
        this.mFormItemHeight = this.getDimension1x4Height();
      } else {
        this.mFormItemHeight = Number(this.mFormStyleConfig.mFormHeight.get(this.mFormItem.cardDimension.toString()));
      }
    }
    log.showDebug('setFormSize width %{public}d, height %{public}d, cardId :%{public}s', this.mFormItemWidth,
      this.mFormItemHeight, this.mFormItem.cardId);
    this.updateNode();
  }

  private setFormSizeWithAnimate(isNeedAnimate = false): void {
    if (isNeedAnimate) {
      animateTo({
        duration: 100,
        curve: Curve.Linear,
      }, () => {
        this.setFormSize();
      })
      return;
    }
    this.setFormSize();
  }

  private updateFormSize(isNeedAnimate = false): void {
    if (!launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop)) {
      return;
    }
    if (this.mFormItem?.cardDimension) {
      this.setFormSizeWithAnimate(isNeedAnimate);
      log.showInfo(`updateFormSize Width = ${this.mFormItemWidth},  Height = ${this.mFormItemHeight}`);
      this.mFormSizeChange = !this.mFormSizeChange;
    }
    // 用于更新一镜到底时钟卡片缩放比例
    this.updateOneShotManager();
    this.mFormItemEvent.initFormInfo(this.mFormItem, this.mFormItemHeight, this.mFormItemWidth,
      this.mFormComponentBuilderId);
  }

  private onLockReceived(): void {
    log.showInfo(`receive msg, lockReceived: ${this.mLockReceived}.`);
    this.mFormItemEvent.showFormBackplaneAnimate(false);
  }

  private updateLocation(): void {
    if (this.needUpdateLocation && !FormCommonUtil.isCardIdInvalid(this.mFormItem.cardId)) {
      log.showInfo('formItem update location: ' + FormLocation.DESKTOP);
      this.needUpdateLocation = false;
      try {
        formHost.updateFormLocation(this.mFormItem.cardId, FormLocation.DESKTOP);
      } catch (error) {
        log.showError(`updateFormLocation error, code: ${error?.code}, message: ${error?.message}`);
      }
    }
  }

  private onCreateFormHandler() {
    if (CheckEmptyUtils.checkStrIsEmpty(this.createFormId)) {
      // 卡片中心添加完成 updateLocation
      this.updateLocation();
    }
    if (!CheckEmptyUtils.checkStrIsEmpty(this.createFormId) && this.createFormId === this.mFormItem.cardId) {
      log.showWarn('add form %{public}s', this.createFormId);
      let delayTime: number = 350;
      this.mFormNameEvent.nameDelayAnimateHandler(delayTime);
      this.mFormComponentEvent.setFormOpacity(FormStyleConstants.DEFAULT_FORM_HIDDEN_OPACITY_VALUE);
    } else {
      this.mFormComponentEvent.setFormOpacity(1);
    }
  }

  updateStyle(): void {
    this.translateX = CheckEmptyUtils.isEmpty(this.desktopStyle) ? 0 : this.desktopStyle.translateX;
    this.translateY = CheckEmptyUtils.isEmpty(this.desktopStyle) ? 0 : this.desktopStyle.translateY;
    this.mFormItemVm.mAnimateOpacity = CheckEmptyUtils.isEmpty(this.desktopStyle) ? 1 : this.desktopStyle.alpha;
    this.mFormItemVm.mAnimateScale = CheckEmptyUtils.isEmpty(this.desktopStyle) ? 1 : this.desktopStyle.scale;
  }

  private updateOneShotManager(): void {
    let oneShotManager: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
    if (this.mFormItem.cardDimension === oneShotManager.getCardDimension() && oneShotManager.isEquals(this.mFormItem)) {
      oneShotManager.setFormScale(1, 1, FormStyleConstants.FORM_PORTRAIT_SCALE_X,
        FormStyleConstants.FORM_PORTRAIT_SCALE_Y);
    }
  }

  onLanguageChange(): void {
    this.getDialogName();
    this.mFormItemEvent.updateFormName().then((appName) => {
      if (!CheckEmptyUtils.checkStrIsEmpty(appName)) {
        this.mFormName = appName;
      }
    });
  }

  private getDialogName(): void {
    if (NoIconAppModel.getInstance().checkIfBundleIsNoIconApp(this.mFormItem.bundleName as string)) {
      let iconInfo: NoIconAppInfo = NoIconAppModel.getInstance().updateNoIconAppInfo(this.mFormItem.bundleName);
      this.updateDialogName(iconInfo.label);
      return;
    }
    this.mResourceManager.getAppNameWithCache(this.mFormItem.appLabelId, this.mFormItem.bundleName,
      this.mFormItem.mainModuleName, '', (value: string) => this.updateDialogName(value));
  }

  private updateDialogName(value: string): void {
    // 将系统迁移场景的SceneBoard应用名称替换为设备应用名称
    this.mFormItemEvent.dealWithFromName().then((appName) => {
      if (!CheckEmptyUtils.checkStrIsEmpty(appName)) {
        log.showWarn(`set appName : ${appName}`);
        value = appName;
      }
      this.formName = value;
      this.dialogName = $r('app.string.is_delete_card', value);
    });
  }

  private setEditModePara(isShowCancelDialog: boolean): void {
    this.isShowCancelDialog = isShowCancelDialog;
  }

  private initFormItemEvent() {
    this.mFormItemEvent = new FormItemRelativeEvent(this.mFormItemVm, this.mFormBackVm, this.mFormMaskVm,
      this.isOuterDesktop);

    if (this.mFormItem.gameCardInfo) {
      this.initOverflowFormEvent();
    }
  }

  private isOverflowForm(): boolean {
    if (!this.mFormItem.gameCardInfo) {
      return false;
    }
    return LiveFormSupportMgr.getInstance().isSupportGameCard() || LiveFormSupportMgr.getInstance().isSupportLiveForm();
  }

  private initOverflowFormEvent(): void {
    if (!this.mFormItem.gameCardInfo) {
      return;
    }

    if (this.mFormItem.gameCardInfo.extensionType === OverflowConstants.ANIMATION_TYPE &&
    LiveFormSupportMgr.getInstance().isSupportSceneAnimation()) {
      this.mFormItemEvent = new OverflowSceneAnimationFormEvent(this.mFormItemVm, this.mFormBackVm,
        this.mFormMaskVm, this.isOuterDesktop);
    } else if (this.isFunInteractionForm()) {
      this.mFormItemEvent = new OverflowFunInteractionFormEvent(this.mFormItemVm, this.mFormBackVm,
        this.mFormMaskVm, this.isOuterDesktop);
    }
  }

  private isFunInteractionForm(): boolean {
    if (!this.mFormItem.gameCardInfo) {
      return false;
    }

    let isGameEngineValid: boolean = HiSysEventUtil.isGameEngineValid();
    let isGrayAppIcon: boolean =
      GrayAppListManager.getInstance().isGrayAppIcon({ bundleName: this.mFormItem.bundleName, appIndex: 0 });
    if (!isGameEngineValid || isGrayAppIcon) {
      log.showWarn(`isGameEngineValid: ${isGameEngineValid}, isGrayAppIcon: ${isGrayAppIcon}`);
      return false;
    }

    log.showInfo(`bundleName:${this.mFormItem.bundleName}, formBindGame:${this.mFormItem.gameCardInfo.formBindGame},` +
      ` subBundleName:${this.mFormItem.gameCardInfo.subBundleName}`);
    // 小蒙游戏卡片单独处理: 校验包名和游戏名
    if (this.mFormItem.bundleName === 'com.ohos.litegames' &&
      this.mFormItem.gameCardInfo.formBindGame === 'com.openharmony.StackingBoxes' &&
      (LiveFormSupportMgr.getInstance().isSupportGameCard() ||
      LiveFormSupportMgr.getInstance().isSupportFunInteraction())) {
      return true;
    }
    return this.mFormItem.gameCardInfo.extensionType === OverflowConstants.INTERACTION_TYPE &&
      LiveFormSupportMgr.getInstance().isSupportFunInteraction();
  }

  private getMenuInfo(): MenuInfo[] {
    let menuInfoList: MenuInfo[] = this.mPageDesktopViewModel.buildCardMenuInfoList(this.mFormItem,
      this.removeFormDialogController, FormConstants.FORM_MANAGER_SHOW_FROM_DESKTOP_FORM_RIGHT_MENU,
      this.deleteFormFunc);

    // PC不需要根据弹出位置判断，必定翻转
    if (!this.mDefaultType) {
      return menuInfoList.reverse();
    }

    if (MenuCommonUtil.isShowBottom(this.mFormMenuVm.mItemPlacement)) {
      menuInfoList.reverse();
    }
    return menuInfoList;
  }

  private getAccessFormName(formName: string, mFormItem: CardItemInfo): string {
    let accessFormName: string = formName;
    // SCENEBOARD_BUNDLE需要排除占位卡的情况
    if (mFormItem.bundleName === CommonConstants.SCENEBOARD_BUNDLE &&
      !FormRelationManager.getInstance().isSceneBoardCard(mFormItem.bundleName, mFormItem.cardName)) {
      accessFormName = ResourceManager.getInstance().getStringByName('lock_screen');
    }
    return `${accessFormName}${ResUtils.getInnerString($r('app.string.form_service'))}`;
  }

  private checkCardDimension(item: CardItemInfo): void {
    if (CheckEmptyUtils.isEmpty(item) || CheckEmptyUtils.isEmptyArr(item.area)) {
      log.showError('card or area empty!');
      return;
    }

    if (!item.cardDimension) {
      log.showError(`fix card cardDimension, id: ${item.cardId}`);
      item.cardDimension = CardItemInfo.getCardDimension(item.area);
    }
  }

  private initRemoveFormDialogController(): void {
    this.removeFormDialogController = new CustomDialogController({
      builder: RemoveFormDialog({
        cancel: () => {
          this.mFormItemEvent.reportRemoveCardEvent(RemoveCardResultType.CANCEL);
        },
        confirm: () => {
          this.mFormItemEvent.doRemoveFormAnimate(this.getIndexInSwiper());
        },
        dialogName: this.dialogName,
        formName: this.formName,
      }),
      autoCancel: true,
      customStyle: !this.mDefaultType,
      showInSubWindow: true,
      alignment: DialogAlignment.Center,
    });
  }

  /**
   * 根据拖动方式和卡片类型，计算得到 MARGIN 偏移 卡片落位会创建两次卡片 传入正常卡片ID框架异常返回一次卡片ID
   * @param isCenterDrag  true = 从卡片中心拖动 | false = 在桌面拖动
   * @param cardType 卡片类型：2x2 / 2x1 / 4x4 / 4x6
   * @returns 最终偏移量
   */
  private getOffsetMargin(isFormCenterDrag: boolean, cardType: string): number {
    switch (cardType) {
      case FeatureConstants.CARD_TYPE_SECOND:
        return isFormCenterDrag ? FeatureConstants.CARD_MARGIN_OFFSET_TWELVE :
          FeatureConstants.CARD_MARGIN_OFFSET_FOURTTEN;
      case FeatureConstants.CARD_TYPE_ONE:
        return FeatureConstants.CARD_MARGIN_OFFSET_FIVE;
      case FeatureConstants.CARD_TYPE_FOUR:
        return isFormCenterDrag ? FeatureConstants.CARD_MARGIN_OFFSET_TWENTY_SEVEN :
          FeatureConstants.CARD_MARGIN_OFFSET_TWENTY_EIGHT;
      case FeatureConstants.CARD_TYPE_SIX:
        return isFormCenterDrag ? FeatureConstants.CARD_MARGIN_OFFSET_FORTY_THREE :
          FeatureConstants.CARD_MARGIN_OFFSET_FORTY_TWO;
      default:
        return FeatureConstants.CARD_MARGIN_OFFSET_ZERO;
    }
  }

  aboutToAppear(): void {
    GlobalContext.getContext().eventHub.on('setFormOpacity', () => {
      this.setFormOpacity = 1;
    })
    let carType: number[] | undefined = this.mFormItem.area;
    if (carType) {
      this.carType = carType[1].toString();
    }
    this.checkCardDimension(this.mFormItem);
    log.showWarn(`build item form, cardId: %{public}s, default activate: %{public}s, area: %{public}s, cardName: %{public}s, bundleName=%{public}s, moduleName: %{public}s,` +
      ` cardDimension: %{public}d, page: %{public}d, column: %{public}d, row: %{public}d, isOuterDesktop: %{public}s`,
      this.mFormItem.cardId, String(this.mFormItem.isDefaultActivated), this.mFormItem.area?.toString(),
      this.mFormItem.cardName, this.mFormItem.bundleName, this.mFormItem.moduleName,
      this.mFormItem.cardDimension, this.mFormItem.page, this.mFormItem.column, this.mFormItem.row,
      this.isOuterDesktop);
    FormCommonUtil.compareCacheAndRdb();
    if (!this.mDefaultType) {
      this.mFormComponentEvent = new PcFormComponentEvent(this.mFormComponentVm);
    }
    this.isFunInteraction = this.mFormItem.gameCardInfo?.extensionType === OverflowConstants.INTERACTION_TYPE ||
      this.mFormItem.gameCardInfo?.gameType === OverflowConstants.QUICK_TYPE_GAMECARD;
    this.initFormItemEvent();
    this.initRemoveFormDialogController();
    this.mFormItemEvent.initFunction(
      (isShowCancelDialog: boolean): void => this.setEditModePara(isShowCancelDialog),
      (): boolean => this.mFormComponentEvent.getFormVisibility(),
      (visibility: boolean): void => this.mFormComponentEvent.setFormVisibility(visibility),
      (): number => this.mFormComponentEvent.getFormOpacity(),
      (opacity: number): void => this.mFormNameEvent.setFormNameOpacity(opacity),
      (formImage: image.PixelMap) => this.setDragImage(formImage),
      (state: boolean) => this.mFormMenuEvent.setMenuShowState(state),
      (state: boolean) => this.mFormComponentEvent.setFormUninstallState(state),
      (value: string) => {
        if (this.formZoomId !== value) {
          this.formZoomId = value;
        }
      }
    );

    this.mFormMenuEvent.initMenuFunc(
      (opacity: number): void => this.mFormComponentEvent.setFormOpacity(opacity),
      (isDisappear: boolean): void => this.mAppNameEvent.appNameDisappearAnimate(isDisappear));

    this.initConfig();
    this.mFormRelativeItemId = `${this.mTag}_FormItem_${this.mFormItem.bundleName}_${this.mFormItem.cardId}`;
    this.mFormComponentId = FormCommonUtil.getFormComponentId(this.mFormItem);
    this.mFormComponentBuilderId = this.mFormComponentId + `column`;
    let appModule: string = this.mFormItemEvent.getFormAppModuleName(this.mFormItem.bundleName);
    this.mFormItem.mainModuleName = appModule ?? this.mFormItem.moduleName;
    this.getDialogName();

    // 刷新放缩组件视图
    this.clearFormZoomTimeoutId = setTimeout(() => {
      if (this.formZoomId !== INVALID_FORM_ZOOM_ID) {
        this.loadFormZoomComponent();
      } else {
        formZoomController.setDragState(false);
      }
      clearTimeout(this.clearFormZoomTimeoutId);
    }, 500);

    this.mMenuInfo = this.mPageDesktopViewModel.buildCardMenuInfoList(this.mFormItem, this.removeFormDialogController,
      FormConstants.FORM_MANAGER_SHOW_FROM_DESKTOP_FORM_RIGHT_MENU, this.deleteFormFunc);

    this.mFormItemEvent.initFormInfo(this.mFormItem, this.mFormItemHeight, this.mFormItemWidth,
      this.mFormComponentBuilderId);
    this.mFormItemEvent.initEventhubEvent();

    this.onCreateFormHandler();
    if (this.isInDrag) {
      this.needUpdateLocation = true; // 说明拖拽添加
      let delayTime: number = 50;
      this.mFormNameEvent.nameDelayAnimateHandler(delayTime);
    }
    if (!CheckEmptyUtils.checkStrIsEmpty(this.createFormId) && this.createFormId === this.mFormItem.cardId) {
      this.needUpdateLocation = true; // 说明卡片中心添加
    }
    const cardNode: BuilderNode<[FormBasicParams]> | null =
      CardNodeControllerManager.getCardNode(this.mFormItem.cardId);
    log.showInfo(`needUpdateLocation = ${this.needUpdateLocation}; cardNode = ${cardNode}`);
    if (!this.needUpdateLocation && cardNode) {
      // 无动效加卡
      this.needUpdateLocation = true;
      this.updateLocation();
    }
    // 将系统迁移场景的SceneBoard占位卡片名称替换为设备应用名称
    this.mFormItemEvent.dealWithFromName().then((appName) => {
      if (!CheckEmptyUtils.checkStrIsEmpty(appName)) {
        this.mFormName = appName;
      }
    });

    if (!CheckEmptyUtils.checkStrIsEmpty(this.mFormItem.cardId)) {
      this.mViewModel.registerViewData(this.mFormItem, this.mFormComponentEvent);
    }
    viewMgrPolicy.registerViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    this.mPageDesktopViewModel.registerUninstallListener(this.unInstallListener);
    this.updateSatisfiedCardList(this.mFormItem);
    if (this.isOuterDesktop) {
      this.registerDeleteOuterCardListener();
      this.registerOuterMenuCloseListener();
    }
    this.checkIsNeedWaitClearCards();
  }

  private loadFormZoomComponent(): void {
    if (this.formZoomId !== this.mFormComponentId) {
      this.showFormZoomSnapshot = false;
      if (this.mFormItem.cardId !== '0') {
        FormModel.getInstance().updateFormInfoById(this.mFormItem);
        this.mFormZoomManager.deleteFormZoomSnapshot();
        this.mFormZoomManager.deleteOldCard();
        this.mFormItemEvent.setFormZoomId();
      }
    }
  }

  aboutToDisappear(): void {
    log.showInfo('FormItemRelative aboutToDisappear');
    setTimeout(()=>{
      GlobalContext.getContext().eventHub.off('setFormOpacity')
    }, 3000)
    if (this.clearFormZoomTimeoutId) {
      clearTimeout(this.clearFormZoomTimeoutId);
      this.clearFormZoomTimeoutId = 0;
    }
    this.removeFormDialogController = null;
    this.mFormItemEvent.unInitEventhubEvent();
    // 注销更新解锁截图事件
    GlobalContext.getContext()?.eventHub.off(SCBConstants.SCENE_CONTAINER_TRANSITION_OUT_START,
      this.exitTransitionStartCallback);
    if (!CheckEmptyUtils.checkStrIsEmpty(this.mFormItem.cardId)) {
      this.mViewModel.unRegisterViewData(this.mFormItem, this.mFormComponentEvent);
    }
    this.mPageDesktopViewModel.unregisterUninstallListener(this.unInstallListener);
    if (this.isOverflowForm() && (this.mFormItemEvent instanceof OverflowSceneAnimationFormEvent ||
      this.mFormItemEvent instanceof OverflowFunInteractionFormEvent)) {
      this.mFormItemEvent.unregisterOverflowListener();
    }
    if (this.isOuterDesktop) {
      localEventManager.unregisterEventListener(this.mDeleteOuterCardListener);
      localEventManager.unregisterEventListener(this.mOuterMenuCloseListener);
    }
    viewMgrPolicy.unRegisterViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
  }

  private checkIsNeedWaitClearCards(): void {
    if (!this.mFormItem.cardId && !this.isClearInvalidCardsDone) {
      log.showWarn(`clear invalid cards not done, do not build no id cards`);
      this.isNeedWaitClearCards = true;
    }
    // 兜底逻辑，如果相关字段没有更新，3S后强制建卡
    const timerId = setTimeout(() => {
      this.isClearInvalidCardsDone = true;
      clearTimeout(timerId);
    }, DELAY_THREE_SECOND);
  }

  private updateSatisfiedCardList(cardItemInfo: CardItemInfo) {
    if (CheckEmptyUtils.isEmpty(cardItemInfo)) {
      log.showError('updateSatisfiedCardList cardItemInfo is empty!');
    }
    if (cardItemInfo.cardName === CLOCK_WEATHER_CARD_NAME) {
      PageDesktopOneShotManager.getInstance().getSatisfiedCardList();
    }
  }

  private setDragImage(formImage: image.PixelMap): void {
    this.dragSnapshot = formImage;
  }

  private initConfig(): void {
    let styleConfig = this.mPageDesktopViewModel.getPageDesktopStyleConfig();
    this.mFormNameSizeInfo.mFormNameHeight = styleConfig.mNameHeight as number;
    this.mFormNameSizeInfo.mFormNameWidth = styleConfig.mNameWidth as number;
    this.mFormNameSizeInfo.mFormNameSize = styleConfig.mNameSize as number;
    this.mFormNameSizeInfo.mNameMargin = styleConfig.mIconNameMargin as number;
    this.mFormNameSizeInfo.mNameFontColor = styleConfig.mNameFontColor;
    this.mFormNameSizeInfo.mNameMarginTop = styleConfig.mIconNameMarginTop as number;
    this.shadowStyle = {
      radius: styleConfig.mFormShadowRadius,
      color: styleConfig.mFormShadowColor,
      offsetY: styleConfig.mFormShadowOffsetY,
    };

    if (this.mFormItem && this.mFormItem.cardDimension) {
      if (this.isOuterDesktop) {
        this.mFormItemWidth =
          Number(this.mFormStyleConfig.mOuterFormWidth.get(this.mFormItem.cardDimension.toString()));
        this.mFormItemHeight =
          Number(this.mFormStyleConfig.mOuterFormHeight.get(this.mFormItem.cardDimension.toString()));
        log.showInfo('initConfig width %{public}d, height %{public}d, radius:%{public}d, cardId :%{public}s',
          this.mFormItemWidth, this.mFormItemHeight, this.mFormItemVm.mFormBorderRadius, this.mFormItem.cardId);
      } else {
        this.mFormItemWidth = Number(this.mFormStyleConfig.mFormWidth.get(this.mFormItem.cardDimension.toString()));
        if (this.mFormItem.isFormDimension1x4) {
          this.isLayoutCenterStyle = true;
          this.mFormItemHeight = this.getDimension1x4Height();
        } else {
          this.mFormItemHeight = Number(this.mFormStyleConfig.mFormHeight.get(this.mFormItem.cardDimension.toString()));
        }
      }
      let formRadiusFromConfig: number = this.mFormStyleConfig.getFormBorderRadius(this.mFormItem.cardDimension);
      if (formRadiusFromConfig !== CommonConstants.INVALID_VALUE) {
        this.mFormItemVm.mFormBorderRadius = formRadiusFromConfig;
      }
      log.showDebug(`initConfig width ${this.mFormItemWidth}, height ${this.mFormItemHeight}, radius ${this.mFormItemVm.mFormBorderRadius}`);
    }
    this.mFormItemEvent.setOuterDesktop(this.isOuterDesktop);
    let supportDimensions: FormZoomSupportInfo[] = FormCommonUtil.getFormZoomSupportInfos(this.mFormItem);
    this.mFormItemVm.supportZoom = supportDimensions.length > 1;

    if (this.mFormItemWidth) {
      this.mFormBackVm.mSizeRatio =
        (this.mFormItemWidth - StyleConstants.CARD_BACKGROUND_SIZE_OFFSET) / this.mFormItemWidth;
    }
  }

  private isEqualToDragItemChange(): void {
    log.showWarn('isEqualToDragItemChange, isDragStart:%{public}s', this.isDragStart);
    if (!this.isDragStart) {
      this.mFormNameEvent.nameAnimateHandler();
      this.mFormItemVm.mAnimateScale = 1;
    }
  }

  private deleteFormFunc: () => void = () => {
    this.isAccessibilityFocus = false;
    this.mFormItemEvent.doRemoveFormAnimate(this.getIndexInSwiper());
  };

  private getScale(): ScaleOptions {
    return {
      x: this.mFormItemVm.mAnimateScale,
      y: this.mFormItemVm.mAnimateScale,
      centerX: !CheckEmptyUtils.isEmpty(this.desktopStyle) && this.desktopStyle.unLockAnimate ?
        this.desktopStyle.centerX : FormStyleConstants.FORM_PORTRAIT_SCALE_X,
      centerY: !CheckEmptyUtils.isEmpty(this.desktopStyle) && this.desktopStyle.unLockAnimate ?
        this.desktopStyle.centerY : !this.mDefaultType ? FormStyleConstants.PC_FORM_PORTRAIT_SCALE_Y :
          FormStyleConstants.FORM_PORTRAIT_SCALE_Y
    }
  }

  private getBaseComponentScale(): ScaleOptions {
    return !this.mDefaultType ? this.getScale() : { x: 1, y: 1 };
  }

  @Builder
  dragIconBuilder() {
    Image(this.dragSnapshot)
      .draggable(false)
      .width(EditModeUtils.convertWithDesktopScale(this.mFormItemWidth))
      .height(EditModeUtils.convertWithDesktopScale(this.mFormItemHeight))
      .syncLoad(true)
      .interpolation(ImageInterpolation.Medium)
      .autoResize(false)
  }

  @Builder
  formZoomPreviewBuilder() {
    Stack() {
      FormZoomPreviewComponent({
        mFormComponentId: this.mFormComponentId,
        mFormItemWidth: this.mFormItemWidth,
        mFormItemHeight: this.mFormItemHeight,
        mFormBorderRadius: this.mFormItemVm.mFormBorderRadius,
      })
    }
    .width(this.mFormItemWidth + HOT_AREA_WIDTH)
    .height(this.mFormItemHeight + HOT_AREA_HEIGHT)
  }

  @Styles
  longPressGestureStyle() {
    .parallelGesture(
      GestureGroup(GestureMode.Parallel,
        // 100ms 空长按手势确保图标优先于编辑模式背板响应长按手势
        LongPressGesture({ repeat: false, duration: EditModeConstants.PAGE_DRAG_SKIP_GESTURE_TIME }),
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_VIBRATOR_TIME })
          .onAction((event: GestureEvent) => {
            this.mFormItemEvent.handleLongPressVibration(this.mFormMenuEvent, event);
            if (this.isOuterDesktop && !editModeManager.isInEditMode()) {
              localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_OUTER_MENU_OPEN, [this.mFormItem,
                false]);
              this.mFormComponentVm.mFormVisible = false;
            }
          })
          .onActionEnd(() => {
            this.mFormItemEvent.handleLongPressVibrationEnd();
          })
          .onActionCancel(() => {
            this.mFormItemEvent.handleLongPressVibrationCancel();
          }),
        LongPressGesture({ repeat: false, duration: NumberConstants.CONSTANT_NUMBER_550 })
          .onAction(() => {
            if (editModeManager.isInEditMode()) {
              this.mFormItemEvent.playLongPressAnimation(false, this.mFormItem.cardDimension,
                StyleConstants.EDIT_MODE_LONG_PRESS_SCALE);
            }
          }),
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_ZOOM_IN_WITH_MENU })
          .onAction(() => {
            this.mFormItemEvent.handleLongPressGestureAction();
          })
          .onActionEnd(() => {
            this.mFormItemEvent.handleLongPressGestureActionEnd();
          })
          .onActionCancel(() => {
            this.mFormItemEvent.handleLongPressGestureActionCancel();
          }),
        LongPressGesture({ repeat: false, duration: NumberConstants.CONSTANT_NUMBER_400 })
          .onAction(() => {
            this.mFormItemEvent.handleFormStatusChange();
          })
      )
    )
    .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
      return this.mFormItemEvent.onGestureJudgeBegin(gestureInfo, event);
    })
  }

  @Styles
  dragStyles() {
    .onDragStart((event: DragEvent) => {
      if (this.formZoomId === this.mFormComponentId) {
        this.formZoomId = INVALID_FORM_ZOOM_ID;
        FormZoomViewManager.getInstance().closeFormZoomView();
      }
      return this.mFormItemEvent.handlerDragStart(event);
    })
    .onDragEnd((event: DragEvent) => {
      this.mFormItemEvent.handlerDragEnd();
      // 拖拽结束，600ms拖拽落位动效后，对于可支持调整大小的卡片显示线框
      setTimeout(() => {
        if (FormZoomManager.getInstance().isReady()) {
          this.mFormItemEvent.setFormZoomId();
        }
      }, 600);
      if (this.isOuterDesktop) {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_OUTER_CARD_DRAG_END,
          this.mFormItem.cardId);
      }
    })
    .dragPreviewOptions({
      mode: DragPreviewMode.DISABLE_SCALE,
      modifier: this.mFormItemEvent.getDragModifier()
    }, {
      // isDragPreviewEnabled: false
    })
    .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
      return this.mFormItemEvent.onGestureJudgeBegin(gestureInfo, event);
    })
  }

  @Builder
  FormMaskBuilder() {
    if (this.mFormBackVm.mIsFormBackOpen) {
      FormMask({
        mFormMaskWidth: this.mFormItemWidth,
        mFormMaskHeight: this.mFormItemHeight,
        mFormBorderRadius: this.mFormItemVm.mFormBorderRadius,
        mFormMaskOpacity: this.mFormMaskVm.mFormMaskOpacity,
        mDropAnimateScale: this.mFormItemVm.mDropAnimateScale,
        mDropAnimateTranslateY: this.mFormItemVm.mDropAnimateTranslateY
      })
    }
  }

  @Builder
  FormBackboardBuilder() {
    if (this.mFormBackVm.mIsFormBackOpen) {
      FormBackboard({
        mFormBackWidth: this.mFormItemWidth,
        mFormBackHeight: this.mFormItemHeight,
        mFormBorderRadius: this.mFormItemVm.mFormBorderRadius,
        mFormBackVm: this.mFormBackVm
      })
    }
  }

  @Builder
  MenuBuilder(isLongPressShow: boolean) {
    FormMenuItem({
      mMenuInfo: this.getMenuInfo(),
      onAppearEventHandle: () => {
        this.mFormMenuEvent.menuAppearHandler(isLongPressShow);
      },
      onDisappearEventHandle: (isClick: boolean) => {
        this.mFormMenuEvent.menuDisappearHandler(isClick, this.mFormItemWidth, this.mFormItemHeight, this.mFormItem);
        this.mFormItemEvent.handleMenuDisappear();
      }
    })
  }

  @Builder
  RightClickMenuBuilder() {
    this.MenuBuilder(false);
  }

  @Builder
  LongPressMenuBuilder() {
    this.MenuBuilder(true);
  }

  @Builder
  FormNameBuilder() {
    if (this.mFormItemEvent.isNeedBuildAppName(this.mFormItemVm.mIsDragItem)) {
      AppName({
        bundleName: this.mFormItem.bundleName,
        moduleName: this.mFormItem.mainModuleName,
        labelId: this.mFormItem.appLabelId,
        appName: this.mFormName,
        isBlockUpdateName: this.mFormItemEvent.isBlockUpdateName(),
        nameHeight: this.mFormNameSizeInfo.mFormNameHeight,
        nameWidth: this.mFormNameSizeInfo.mFormNameWidth,
        nameSize: this.mFormNameSizeInfo.mFormNameSize,
        nameFontColor: this.mFormNameSizeInfo.mNameFontColor,
        marginTop: this.mFormNameSizeInfo.mNameMargin + this.mFormNameSizeInfo.mNameMarginTop,
        colStart: this.mFormItem.column,
        colEnd: this.mFormNameEvent.calculateColEnd(this.mFormItem),
        rowEnd: this.mFormNameEvent.calculateRowEnd(this.mFormItem),
        getIndexInSwiper: this.getIndexInSwiper,
        isDesktopItem: this.mIsDesktopItem,
        parentItem: this.mFormItem as Object as GridLayoutItemInfo,
        alignOption: {
          top: { anchor: this.mFormComponentBuilderId, align: VerticalAlign.Bottom },
          middle: { anchor: this.mFormComponentBuilderId, align: HorizontalAlign.Center }
        },
        modifier: this.mAppNameVm.modifier,
        zValue: -2,
        isOuterDesktop: this.isOuterDesktop,
        enableDrag: false
      })
        .alignRules({
          top: { anchor: this.mFormComponentBuilderId, align: VerticalAlign.Bottom },
          middle: { anchor: this.mFormComponentBuilderId, align: HorizontalAlign.Center }
        })
        .opacity((this.formZoomId === this.mFormComponentId && this.showFormZoomSnapshot) ?
          0 : this.mFormNameVm.mNameOpacity)
    }
  }

  @Builder
  PCFormNameBuilder() {
    Column() {
      this.FormNameBuilder()
    }
    .margin({
      top: this.mFormNameSizeInfo.mNameMarginTop
    })
    .id(`PC_FormName_${this.mFormItem.cardId}`)
    .alignRules({
      top: { anchor: this.mFormComponentBuilderId, align: VerticalAlign.Bottom },
      middle: { anchor: this.mFormComponentBuilderId, align: HorizontalAlign.Center }
    })
    .opacity(this.mFormNameVm.mNameOpacity)
    .bindContextMenu(this.RightClickMenuBuilder, ResponseType.RightClick, this.mFormMenuEvent.rightClickPCContext())
    .onAppear(() => {
      let isSetFormOpacity = AppStorage.get('setFormOpacity') === 0;
      if (isSetFormOpacity) {
        return;
      }
      this.setFormOpacity = 1
    })
    .zIndex(-2)
  }

  @Builder
  BaseFormComponent(skeletonEnable?: boolean) {
    FormBaseComponent({
      mFormItem: this.mFormItem,
      mFormItemWidth: this.mFormItemWidth,
      mFormItemHeight: this.mFormItemHeight,
      mFormSizeChange: this.mFormSizeChange,
      mFormBorderRadius: this.mFormItemVm.mFormBorderRadius,
      mDropAnimateTranslateY: 0,
      mFormComponentVm: this.mFormComponentVm,
      mFormComponentEvent: this.mFormComponentEvent,
      getFormId: async (newCardId: string) => {
        if (this.mFormItem.isDefaultActivated) {
          log.showInfo(`add activate default active form: ` +
            `${this.mFormItem.bundleName}, ${newCardId}, ${this.mFormItem.cardName}}`);
          this.mOverflowViewModel.addDefaultActivatedFormId(newCardId);
        }
        if (this.mFormItem.cardId !== newCardId || this.mFormItem.extend1) {
          await this.mFormViewModel.updateCardIdOfPreloadForm(this.mFormItem, newCardId, this.isOuterDesktop);
          this.mPageDesktopViewModel.lightPagingFiltering();
        }
        if (this.mFormItem.isDefaultActivated) {
          log.showInfo(`add activate default active form: ` +
            `${this.mFormItem.bundleName}, ${newCardId}, ${this.mFormItem.cardName}}`);
          this.mOverflowViewModel.addDefaultActivatedFormId(newCardId);
          try {
            let status: string = systemParameterEnhance.getSync('persist.phone_focus.advance.mode.status');
            if (status === CLOUD_MODE_TWO) {
              log.showWarn('enter cloud mode two, start activateDefaultActivatedForms');
              this.mOverflowViewModel?.activateSceneAnimation(newCardId);
            }
          } catch (err) {
            log.showError('systemParameterEnhance getSync failed');
          }
        }
      },
      clickForm: (): void => {
        // 卡片上锁状态启动：需要监听主应用保护状态变化
        if (CardLockManager.getInstance().mainAppHasLock(this.mFormItem.bundleName) &&
          !CardLockManager.getInstance().getLockedCardIsReleased(this.mFormItem.bundleName, this.mFormItem.cardId)) {
          GlobalContext.getContext()?.eventHub.on(SCBConstants.SCENE_CONTAINER_TRANSITION_OUT_START,
            this.exitTransitionStartCallback);
        }
        this.mFormItemEvent.formClickEvent();
      },
      isOuterDesktop: this.isOuterDesktop,
      skeletonEnable: skeletonEnable,
      shadowStyle: this.shadowStyle,
    })
      .onClick((event: ClickEvent) => {
        // 编辑模式屏蔽了卡片组件的hitTestBehavior 为None,
        // 需要在这里捕获事件方式冒泡到桌面，触发桌面点击事件导致退出编辑模式
        return;
      })
      .onTouch((event: TouchEvent) => {
        if (event.type === TouchType.Down) {
          // 在此处记录 formComponent 点击情况，作为后续主动触发卡片视乎，回调接口判断的依据
          this.mFormItemEvent?.updateConnectionInfo();
        }
      })
      .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
      // 当前卡片为游戏卡片，且设备类型为手机时， enabled 恒为 false，阻断卡片向元服务页面透传事件
      .enabled(this.mFormItemVm.isFormEnabled)
      .visibility(this.mFormItemVm.formVisibilityStatus)
      .scale(this.getBaseComponentScale())
      .opacity(this.isInDrag ? CommonConstants.FORM_HIDDEN_OPACITY : 1)
      .borderRadius(this.mFormItemVm.mFormBorderRadius)
      .clip(true)
  }

  // 开始退出应用 动效开始
  private exitTransitionStartCallback: () => void = () => {
    log.showInfo('exitTransitionStartCallback done');
    GlobalContext.getContext()?.eventHub.off(SCBConstants.SCENE_CONTAINER_TRANSITION_OUT_START,
      this.exitTransitionStartCallback);
    if (CardLockManager.getInstance().mainAppHasLock(this.mFormItem.bundleName) &&
      !CardLockManager.getInstance().getLockedCardIsReleased(this.mFormItem.bundleName, this.mFormItem.cardId)) {
      // 上锁状态 return;
      log.showInfo('card is locked, update closeSnapshot abort.');
      return;
    }
    try {
      const img: image.PixelMap = componentSnapshot.getSync(this.mFormComponentId);
      PixelMapUtil.addName(img, 'FormItemRelative_exit_image');
      CloseAppManager.getInstance().setCardStartSnapshot(this.mFormComponentId, img);
      img?.release();
    } catch (e) {
      log.showError(`set form snap fail: ${e?.code}`);
    }
  }

  @Styles
  formCommonStyle() {
    .size({ width: this.mFormItemWidth, height: this.mFormItemHeight })
    .borderRadius(this.mFormItemVm.mFormBorderRadius)
    .scale({ x: this.mFormItemVm.mDropAnimateScale, y: this.mFormItemVm.mDropAnimateScale })
    .onTouch((event: TouchEvent): void => {
      this.mFormItemEvent.handleTouchEvent(event, this.mFormComponentId, this.isInDrag);
      this.mFormMenuEvent.setAppMenuPosition(event, this.mFormComponentId, this.mMenuInfo);
    })
  }

  private showContextMenu(): boolean {
    let menuInfo: MenuInfo[] =
      this.mPageDesktopViewModel.buildCardMenuInfoList(this.mFormItem, this.removeFormDialogController,
        FormConstants.FORM_MANAGER_SHOW_FROM_DESKTOP_FORM_RIGHT_MENU, this.deleteFormFunc);
    if (menuInfo?.length > 0) {
      return true;
    }
    return false;
  }

  private isLockLayoutInEditmode(): boolean {
    return lockLayoutManager.isLockLayout() && this.editModeState.isInEditMode();
  }

  private getMenuOffset(): Position {
    let offset: Position = { x: 0 };
    if (this.mFormItemEvent.enableFormZoom()) {
      if (this.mFormMenuVm.mItemPlacement === Placement.BottomLeft ||
        this.mFormMenuVm.mItemPlacement === Placement.TopLeft) {
        offset.x = HOT_AREA_WIDTH / 2;
      } else if (this.mFormMenuVm.mItemPlacement === Placement.BottomRight ||
        this.mFormMenuVm.mItemPlacement === Placement.TopRight) {
        offset.x = -HOT_AREA_WIDTH / 2;
      }
    }
    return offset;
  }

  @Builder
  FormComponentBuilder() {
    Stack() {
      if (!this.isNeedWaitClearCards || this.isClearInvalidCardsDone) {
        this.BaseFormComponent()
      }
      if (this.mFormItemVm.isOverflowFormEnable) {
        OverflowFormItem({
          singleContext: this.singleContext,
          mFormItem: this.mFormItem,
          getIndexInSwiper: this.getIndexInSwiper,
          mOverflowFormItemEvent: this.isFunInteraction
            ? this.mFormItemEvent as object as OverflowFunInteractionFormEvent :
            this.mFormItemEvent as object as OverflowSceneAnimationFormEvent,
          mFormItemWidth: this.mFormItemWidth,
          mFormItemHeight: this.mFormItemHeight,
          mFormComponentVm: this.mFormComponentVm,
          mFormBorderRadius: this.mFormItemVm.mFormBorderRadius,
          mFormComponentBuilderId: this.mFormComponentBuilderId,
          mFormRelativeItemId: this.mFormRelativeItemId,
          isOuterDesktop: this.isOuterDesktop
        })
      }
    }
    .margin({ top: this.mFormMarginTop })
    .formCommonStyle()
    .bindContextMenu(this.RightClickMenuBuilder, ResponseType.RightClick, this.mFormMenuEvent.rightClickContext())
    .bindContextMenu(!(OutdoorConfig.getInstance().isInOutdoorMode() ||
    LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) &&
    this.mFormMenuVm.mIsMenuShow && !this.isOuterDesktop,
      this.showContextMenu() ? this.LongPressMenuBuilder : (): void => {
      },
      this.mFormMenuEvent.longPressContext(this.mFormItem.cardDimension, this.getMenuOffset(),
        this.mFormItemEvent.enableFormZoom() ? () => {
          this.formZoomPreviewBuilder()
        } : undefined))
    .dragStyles()
    .translate({ y: this.mFormItemVm.mDropAnimateTranslateY })
    .id(this.mFormComponentBuilderId)
    .alignRules(this.isLayoutCenterStyle ?
      {
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        center: { anchor: '__container__', align: VerticalAlign.Center }
      } :
      {
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        top: { anchor: '__container__', align: VerticalAlign.Top },
      })
    .opacity(this.mFormComponentVm.mFormOpacity)
    .onHover((isHover: boolean) => {
      this.mFormItemEvent.onHoverEvent(isHover);
    })
    .onMouse((event: MouseEvent) => {
      this.mFormItemEvent.onMouseEvent(event);
    })
    .onClick((event: ClickEvent) => {
      // 编辑模式下卡片组件的hitTestBehavior为None,
      // 需要在这里捕获事件，防止冒泡到桌面触发桌面点击事件导致退出编辑模式
      this.mFormItemEvent.handleFormWrapperClickEvent();
    })
    .accessibilityLevel(this.isAccessibilityMode ?
      (this.mFormItem.gameCardInfo && !this.mFormItemVm.isOverflowFormEnable ? 'yes' : 'no') : 'auto')
    .attributeModifier(this.mFormItemEvent.getFormComponentModifier())
    .parallelGesture(
      LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_ZOOM_IN_WITH_MENU })
        .onAction((event?: GestureEvent) => {
          this.mFormItemEvent.handleLongPressGestureEvent(this.mFormComponentId, this.isInDrag);
        })
    )
  }

  @Builder
  PCFormComponentBuilder() {
    Column() {
      this.BaseFormComponent(!this.isInDrag && !this.mViewModel.isInScreenRotateAni() ? true : undefined)
    }
    .opacity(this.setFormOpacity)
    .bindContextMenu(this.RightClickMenuBuilder, ResponseType.RightClick, this.mFormMenuEvent.rightClickPCContext())
    .bindContextMenu(this.mFormMenuVm.mIsMenuShow, this.LongPressMenuBuilder, this.mFormMenuEvent.longPressPCContext())
    .margin({ top: this.mFormMarginTop + this.getOffsetMargin(this.isFormCenterDrag, this.carType)})
    .formCommonStyle()
    .id(this.mFormComponentBuilderId)
    .dragStyles()
    .alignRules({
      middle: { anchor: '__container__', align: HorizontalAlign.Center },
      top: { anchor: '__container__', align: VerticalAlign.Top },
    })
    .onHover((isHover: boolean) => {
      this.mFormItemEvent.onHoverEventHandler(isHover, this.mFormItem.cardDimension);
    })
    .parallelGesture(
      GestureGroup(GestureMode.Parallel,
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_MENU_SHOW_TIME })
          .onAction((event: GestureEvent) => {
            if (event?.source === SourceType.TouchScreen) {
              this.mFormMenuEvent.setMenuShowState(true);
            }
          })
      )
    )
  }

  build() {
    RelativeContainer() {
      if (!this.mDefaultType) {
        this.PCFormComponentBuilder()
        this.PCFormNameBuilder()
      } else {
        this.FormBackboardBuilder()
        this.FormComponentBuilder()
        this.FormMaskBuilder()
        this.FormNameBuilder()
      }
    }
    .id(this.mFormRelativeItemId)

    // 当 overflowForm 正在运行同时处于暂停或者激活态时，允许卡片内部组件获得焦点
    .focusable(this.mDefaultType && this.mFormItemVm.formVisibilityStatus !== Visibility.Visible)
    .opacity(this.isDragStart ? CommonConstants.FORM_HIDDEN_OPACITY : this.mFormItemVm.mAnimateOpacity)
    .scale(!this.mDefaultType ? {} : this.getScale())
    .foregroundEffect({ radius: this.mFormItemVm.mAnimateBlur })
    .translate({ x: this.translateX, y: this.translateY })
    .visibility(this.isShowCancelDialog ? Visibility.Hidden : Visibility.Visible)
    .size(this.mViewModel.getComponentSize(this.mFormItemWidth, this.mFormItemHeight, this.isOuterDesktop))
    .longPressGestureStyle()
    .padding({ top: this.mDefaultType ? StyleConstants.DEFAULT_0 : StyleConstants.DEFAULT_4 })
    .accessibilityLevel(this.isAccessibilityFocus ? 'yes' : 'no-hide-descendants')
    .accessibilityDescription(this.isAccessibilityMode && !this.isLockLayoutInEditmode() ?
      ResUtils.getInnerString($r('app.string.cc_accessibility_str_long_click')) : ',')
    .accessibilityText(this.isOuterDesktop ? DesktopAccessibilityUtils
      .getOuterDesktopCardAccessibilityText(this.mFormItem, this.isAccessibilityMode, this.isOuterDesktop) :
      this.getAccessFormName(this.formName, this.mFormItem)
    )
  }
}
