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
import componentSnapshot from '@ohos.arkui.componentSnapshot';
import curves from '@ohos.curves';
import { performanceMonitor } from '@kit.ArkUI';
import {
  CardItemInfo,
  CommonConstants,
  FormCommonUtil,
  FormModel,
  GridLayoutUtil,
  EditModeUtils,
  AppItemInfo,
  FormCenterViewManager,
  FormEditViewManager,
  FormManager,
  FormEditViewParam,
  FolderManager,
  StyleConstants,
} from '@ohos/launchercommon';
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  DomainName,
  TraceUtil
} from '@ohos/basicutils';
import {
  ViewController,
  ViewType,
  ViewCallback,
  GlobalContext,
  IconResourceManager,
  ResourceManager,
  viewMgrPolicy,
  localEventManager,
} from '@ohos/frameworkwrapper';
import { ItemUtils } from '@ohos/componenthelper';
import { RectInfo } from '@ohos/basicutils';
import { SCBUnlockTransitionController, SCBSceneSessionManager, launcherStatusUtil } from '@ohos/windowscene';
import { animateExBreak, animateExTo, animateExDelete } from '@ohos/windowscene/Index';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { ForceType, GravityAnimationConfig, GravityAnimationManager } from '@ohos/componentanimator/Index';
import { AppIconModel } from '@ohos/launchercommon/Index';
import { FormCenterViewParam } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { IconPicType } from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/IconInfo';
import IconInfo from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/IconInfo';
import { SwiperLoadData } from '@ohos/swiperdata';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { FormInLineBorder } from '../../formcenter/view/atomicview/formitem/CommonForm';
import FormStyleConstants from '../common/constants/FormStyleConstants';
import FormConstants from '../common/constants/FormConstants';
import { FormUtil } from '../util/FormUtil';
import { FormViewModel } from '../viewmodel/FormViewModel';
import { FormCenterViewData } from '../viewmodel/FormCenterViewData';
import { FormCenterViewModel } from '../viewmodel/FormCenterViewModel';
import { FormEditViewData } from '../viewmodel/FormEditViewData';
import { FormStyleConfig } from '../common/FormStyleConfig';

const TAG = 'FormCompanionComponent';
const DELAY_TIME: number = 100;
const BG_BORDER_RADIUS: number = 20;
const ADAPTIVE_ICON_FACTOR: number = 1.5;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const ANIMATE_EX_BREAK: string = 'animateExBreak';
const ANIMATE_SECOND: string = 'doFinaleAnimateSecond';
const ANIMATE_FIRST: string = 'doFinaleAnimateFirst';
const COMPANION_HIDDEN: string = 'isCompanionHidden';
const GET_MANAGE_ERROR: string = 'getManageError';

/**
 * Form Companion Component (phone adaptation).
 */
@Component
export struct FormCompanionComponent {
  @StorageLink('manageFormItem') manageFormItem: CardItemInfo = new CardItemInfo();
  @StorageLink('enterFormManager') @Watch('onMenuClick') isEnterFormManager: boolean = false;
  @StorageLink('enterFormEdit') @Watch('onMenuClick') isEnterFormEdit: boolean = false;
  @StorageProp('lockReceived') @Watch('destroyCompanionComponent') lockReceived: number = 0;
  @StorageLink('notifyEnterFormManagerAnimate') @Watch('startEnterAnim') formId: string = '';
  @StorageLink('formManagerId') @Watch('getManageFormIcon') formManagerId: string = '';
  @StorageProp('screenWidth') screenWidth: number = 0;
  @StorageProp('screenHeight') screenHeight: number = 0;
  @StorageProp('currColorMode') currColorMode: number = 1;
  @State translateX: number = 0;
  @State translateY: number = 0;
  @State finalScaleX: number = 1;
  @State finalScaleY: number = 1;
  @State foregroundScale: number = 1;
  @State formOpacity: number = 1;
  @State manageFormOpacity: number = 0;
  @State isCompanionShow: boolean = false;
  @State formIcon: image.PixelMap | undefined = undefined;
  @State manageFormIcon: image.PixelMap | undefined = undefined;
  @State appIcon: string | undefined = undefined;
  @State isAdaptiveIcon: boolean = false;
  @State companionRadius: number = 0;
  @State backgroundRadius: number = 0;
  @State backgroundOpacity: number = 1;
  @State backBoardColor: Resource = $r('app.color.normal_form_background_color');
  @State formShadowColor: Resource = $r('app.color.normal_form_manager_shadow_color');
  private formManagerShowFrom: number = FormConstants.FORM_MANAGER_SHOW_FROM_DESKTOP_APP_RIGHT_MENU;
  private isEnterFromApp: boolean = true;
  private initWidth: number = 0;
  private initHeight: number = 0;
  private finalWidth: number = 0;
  private finalHeight: number = 0;
  private initCenterX: number = 0;
  private initCenterY: number = 0;
  private scaleTempX: number = 1;
  private scaleTempY: number = 1;
  private bgImage: string = '';
  private foreground: string = '';
  private desktopContext?: Context = GlobalContext.getContext();
  private cardDimension: number = CommonConstants.CARD_DIMENSION_1x2;
  private cardScale: number = 1;
  private supportFormZoomDimensions: number[] = [
    CommonConstants.CARD_DIMENSION_1x2,
    CommonConstants.CARD_DIMENSION_2x2,
    CommonConstants.CARD_DIMENSION_2x4,
    CommonConstants.CARD_DIMENSION_4x4,
  ];
  // 有些1*2卡片应用进入卡片管理时，背板和截图设置尺寸无法贴合，导致有白边，如智慧生活，对背板添加缩放
  private backScale: number = 0.98;
  // private isCompanionShowClear?: number;
  @State behaviorTransparent: boolean = false;

  aboutToDisappear(): void {
    this.deleteAnimateEx();
  }

  private destroyCompanionComponent(sources?: string): void {
    log.showInfo(`destroyCompanionComponent: ${sources}`);
    this.deleteAnimateEx();
    // clearTimeout(this.isCompanionShowClear);
    // if (this.isCompanionShowClear) {
    //   this.isCompanionShowClear = undefined;
    // }
    this.isCompanionShow = false;
    this.isEnterFormManager = false;
    this.isEnterFormEdit = false;
    GlobalContext.getContext()?.eventHub.emit('enterFormManagerDone');
    GlobalContext.getContext()?.eventHub.emit('enterFormEditDone');
    AppStorage.setOrCreate<boolean>('formIndexFormManageAllowShow', true);
    this.manageFormItem = new CardItemInfo();
    this.desktopContext?.eventHub.off(CommonConstants.EVENTHUB_FORM_MANAGER_EXIT);
    this.desktopContext?.eventHub.off('interruptFormEffect');
    this.backgroundOpacity = 1;
    this.appIcon = undefined;
    this.delayReleasePixmap(this.formIcon, 0);
    this.delayReleasePixmap(this.manageFormIcon, 0);
    this.formIcon = undefined;
    this.manageFormIcon = undefined;
    this.bgImage = '';
    this.foreground = '';
    this.translateX = 0;
    this.translateY = 0;
    this.formOpacity = 1;
    this.manageFormOpacity = 0;
    this.initCenterX = 0;
    this.initCenterY = 0;
    this.initWidth = 0;
    this.initHeight = 0;
    this.finalWidth = 0;
    this.finalHeight = 0;
    this.formManagerId = '';
    this.formId = '';
    this.behaviorTransparent = false;
    this.formShadowColor = $r('app.color.normal_form_manager_shadow_color');
    FormCenterViewManager.getInstance().setIsInFormEnterAnimate(false);
    if (this.manageFormItem.isTransparent) {
      this.backBoardColor = $r('app.color.gradient_transparent_form_background_color');
    }
  }

  private deleteAnimateEx(): void {
    let firstRes: boolean = animateExDelete(ANIMATE_FIRST);
    let secondRes: boolean = animateExDelete(ANIMATE_SECOND);
    log.showInfo(`remove animateExTo object firstRes = ${firstRes}, secondRes = ${secondRes}`);
  }

  private updateIconInfo(): void {
    let bundleName: string = this.manageFormItem.bundleName;
    let moduleName: string = this.manageFormItem.moduleName;
    IconResourceManager.getInstance().getIconResource(bundleName, moduleName, this.manageFormItem.abilityName)
      .then((cache: IconInfo) => {
        if (cache.iconType !== IconPicType.ADAPTIVE) {
          this.isAdaptiveIcon = false;
          this.appIcon = cache.combinePic;
        } else {
          this.isAdaptiveIcon = true;
          this.bgImage = cache.adaptivePic[0];
          this.foreground = cache.adaptivePic[1];
        }
      });
  }

  getAppResourceCache(cacheKey: string, cacheType: string): Map<string, object> {
    return ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as Map<string, object>;
  }

  private handleEnterData(cardDimension: number, manageIndex: number): void {
    this.calculateFinalSize(cardDimension);
  }

  private isSupportFrom(): boolean {
    return this.formManagerShowFrom === FormConstants.FORM_MANAGER_SHOW_FROM_DESKTOP_APP_RIGHT_MENU ||
      this.formManagerShowFrom === FormConstants.FORM_MANAGER_SHOW_FROM_RECENT_APP_RIGHT_MENU ||
      this.formManagerShowFrom === FormConstants.FORM_MANAGER_SHOW_FROM_DESKTOP_FORM_RIGHT_MENU
  }

  private showEnterFormManager(): void {
    let formItem: CardItemInfo[] = AppStorage.get('formItem') as CardItemInfo[];
    if (!formItem || formItem.length === 0) {
      log.showWarn(`app ${this.manageFormItem.bundleName} get no forms`);
      return;
    }
    if (this.manageFormItem.isTransparent) {
      this.backScale = 1;
      this.backBoardColor = $r('app.color.transparent_form_background_color');
    } else {
      this.backBoardColor = $r('app.color.normal_form_background_color');
    }

    // const supportFormZoom: boolean = this.supportFormZoomDimensions.includes(this.manageFormItem.cardDimension);
    if (this.isEnterFromApp) {
      // 获取默认卡片
      let defaultFormIndex: number = formItem.findIndex(i => i.isDefaultCardDimension === i.cardDimension);
      let currentFormIndex: number = defaultFormIndex === -1 ? 0 : defaultFormIndex;
      this.cardDimension = formItem[currentFormIndex].cardDimension;
      this.handleEnterData(formItem[currentFormIndex].cardDimension, defaultFormIndex);
    } else {
      this.cardDimension = this.manageFormItem.cardDimension;
      this.handleEnterData(this.manageFormItem.cardDimension, this.getManageFormInfoIndex(formItem));
    }
    this.cardScale = FormCenterViewData.getInstance().getFormDimensionScale(this.cardDimension);
    this.desktopContext?.eventHub.on(CommonConstants.EVENTHUB_FORM_MANAGER_EXIT, () => {
      log.showInfo('on manager exit, release enter animate');
      animateExBreak(ANIMATE_FIRST, 'break by close or open');
      animateExBreak(ANIMATE_SECOND, 'break by close or open');
      this.destroyCompanionComponent(ANIMATE_EX_BREAK);
    })
    this.desktopContext?.eventHub.on('interruptFormEffect', () => {
      animateExBreak(ANIMATE_FIRST, 'break by close or swiper');
      animateExBreak(ANIMATE_SECOND, 'break by close or swiper');
      this.destroyCompanionComponent(ANIMATE_EX_BREAK);
    })
    this.finalScaleX = this.scaleTempX === 0 ? 1 : 1 / this.scaleTempX;
    this.finalScaleY = this.scaleTempY === 0 ? 1 : 1 / this.scaleTempY;
    this.foregroundScale = 1;
    this.backgroundOpacity = FormStyleConstants.DEFAULT_FORM_HIDDEN_OPACITY_VALUE;
    this.formOpacity = FormStyleConstants.DEFAULT_FORM_HIDDEN_OPACITY_VALUE;
    this.manageFormOpacity = FormStyleConstants.DEFAULT_FORM_HIDDEN_OPACITY_VALUE;

    let shortScaleTemp: number = Math.min(this.scaleTempX, this.scaleTempY);
    let defaultRadius: number = FormUtil.getManagerFormRadius(this.cardDimension);
    this.companionRadius = shortScaleTemp * defaultRadius;
    this.backgroundRadius = shortScaleTemp < 1 ? BG_BORDER_RADIUS * shortScaleTemp :
      defaultRadius * shortScaleTemp;
    log.showWarn('start scaleX: ' + this.finalScaleX + ' finalY: ' + this.finalScaleY +
      ' defaultRadius: ' + defaultRadius)
    this.isCompanionShow = true;
    FormCenterViewManager.getInstance().setIsInFormEnterAnimate(true);
    // this.isCompanionShowClear = setTimeout(() => {
    //   if (this.isCompanionShow) {
    //     this.isCompanionShow = false;
    //   }
    // }, 3600);
  }

  /**
   * Get current form index
   */
  private getManageFormInfoIndex(formItem: CardItemInfo[]): number {
    let manageIndex: number = 0;
    if (!formItem) {
      return manageIndex;
    }

    for (let i = 0; i < formItem.length; i++) {
      if (formItem[i].bundleName === this.manageFormItem.bundleName &&
        formItem[i].abilityName === this.manageFormItem.abilityName &&
        formItem[i].moduleName === this.manageFormItem.moduleName &&
        formItem[i].cardName === this.manageFormItem.cardName &&
        (formItem[i].area as number[]).toString() === (this.manageFormItem.area as number[]).toString()) {
        manageIndex = i;
        log.showInfo(`getManageFormInfoIndex start ${manageIndex}`);
        return manageIndex;
      }
    }
    return manageIndex;
  }

  private doFinaleAnimate(shortScaleTemp: number, curStartTime: number): void {
    if (this.isEnterFromApp) {
      if (this.manageFormItem.isTransparent) {
        this.backgroundOpacity = 1;
      } else {
        this.backgroundOpacity = 0;
      }
      this.finalScaleX = 1;
      this.finalScaleY = 1;
      this.foregroundScale = shortScaleTemp;
      this.destroyCompanionComponent(ANIMATE_FIRST);
      return;
    }

    const isOuter: boolean = launcherStatusUtil.getShowOutLauncherStatus();
    animateExTo(ANIMATE_FIRST, {
      curve: curves.springMotion(0.468, 0.63),
    }, () => {
      if (this.manageFormItem.isTransparent) {
        this.backgroundOpacity = 1;
      } else {
        this.backgroundOpacity = 0;
      }
      this.finalScaleX = 1;
      this.finalScaleY = 1;
      this.foregroundScale = shortScaleTemp;
    }, () => {
      TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_ENTER_FORM_MANAGER);
      const animateSecondTime: number = 1600 - (new Date().getTime() - curStartTime);
      log.showInfo(`animateSecondTime: ${animateSecondTime}`);
      if (!isOuter && !this.manageFormItem.isTransparent && animateSecondTime > 0) {
        let delayTime: number = this.isEnterFromApp ? 0 : animateSecondTime;
        localEventManager.sendLocalEvent(FormConstants.FORM_MOTION_EVENT, delayTime);
        this.behaviorTransparent = true;
        if (this.isEnterFormEdit) {
          localEventManager.sendLocalEventSticky(FormConstants.FORM_EDIT_SHOW, delayTime);
        }
        this.behaviorTransparent = true;
        animateExTo(ANIMATE_SECOND, {
          delay: delayTime,
          duration: 250,
          curve: Curve.Sharp,
        }, () => {
          this.manageFormOpacity = 0
          this.backgroundOpacity = 0;
          this.formShadowColor = $r('app.color.gradient_form_manager_shadow_color');
          if (this.manageFormItem.isTransparent) {
            this.backBoardColor = $r('app.color.gradient_transparent_form_background_color');
          }
        }, () => this.destroyCompanionComponent(ANIMATE_SECOND))
      } else {
        this.destroyCompanionComponent(ANIMATE_FIRST);
      }
    });
  }

  private startEnterAnim(): void {
    if (!this.isCompanionShow) {
      this.destroyCompanionComponent(COMPANION_HIDDEN);
      return;
    }
    if (!this.manageFormItem.isTransparent) {
      this.backgroundOpacity = 0;
    }

    this.formOpacity = 1;

    // 进卡片管理页面
    if (this.isEnterFormManager) {
      let param: FormCenterViewParam = new FormCenterViewParam();
      param.bundleName = this.manageFormItem.bundleName;
      param.formInfo = this.manageFormItem;
      if (FormModel.getInstance().isSupportFormCenterSplit()) {
        FormCenterViewManager.getInstance().openFormCenterView(param);
      } else {
        FormCenterViewManager.getInstance().openFormManagerView(param);
      }
    // 卡片编辑
    } else if (this.isEnterFormEdit) {
      let param: FormEditViewParam = new FormEditViewParam();
      param.bundleName = this.manageFormItem.bundleName;
      param.formInfo = this.manageFormItem;
      FormEditViewManager.getInstance().openFormEditView(param);
    }
    log.showWarn('startEnterAnim');

    let endPosition: Position = { x: 0, y: 0 };
    // 获取卡片中心位置
    if (this.isEnterFormManager) {
      endPosition = FormCenterViewData.getInstance().getAppFormsCenterPosition();
    }
    // 获取编辑页面卡片中心位置
    if (this.isEnterFormEdit) {
      endPosition = FormEditViewData.getInstance().getAppFormsCenterPosition(this.manageFormItem);
    }
    let translateTempX: number = Number(endPosition.x) - this.initCenterX;
    let translateTempY: number = Number(endPosition.y) - this.initCenterY;
    let shortScaleTemp: number = Math.min(this.scaleTempX, this.scaleTempY);
    TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_ENTER_FORM_MANAGER);
    const curStartTime: number = new Date().getTime();

    if (this.isEnterFromApp) {
      if (this.manageFormItem.isTransparent) {
        this.backgroundOpacity = 1;
      }
      this.foregroundScale = 1.1 * shortScaleTemp;
      this.finalScaleX = 1.1;
      this.finalScaleY = 1.1;
      this.formOpacity = 0;
      this.manageFormOpacity = 1;
      let radius: number = FormUtil.getManagerFormRadius(this.cardDimension);
      this.companionRadius = radius * this.cardScale;
      this.backgroundRadius = this.companionRadius;

      this.translateX = translateTempX;
      this.translateY = translateTempY;
      this.doFinaleAnimate(shortScaleTemp, curStartTime);
      return;
    }

    animateTo({
      curve: curves.springMotion(0.468, 0.93),
    }, () => {
      this.translateX = translateTempX;
      this.translateY = translateTempY;
    });

    animateTo({
      duration: 250,
      curve: Curve.Sharp,
      onFinish: () => this.doFinaleAnimate(shortScaleTemp, curStartTime)
    }, () => {
      if (this.manageFormItem.isTransparent) {
        this.backgroundOpacity = 1;
      }
      this.foregroundScale = 1.1 * shortScaleTemp;
      this.finalScaleX = 1.1;
      this.finalScaleY = 1.1;
      this.formOpacity = 0;
      this.manageFormOpacity = 1;
      let radius: number = FormUtil.getManagerFormRadius(this.cardDimension);
      this.companionRadius = radius * this.cardScale;
      this.backgroundRadius = this.companionRadius;
    });
  }

  private getManageFormIcon(manageIndex: number): void {
    if (CheckEmptyUtils.checkStrIsEmpty(this.formManagerId) || (!this.isEnterFormManager && !this.isEnterFormEdit)) {
      log.showInfo('formManagerId=%{public}s, isEnterFormManager=%{public}s, isEnterFormEdit=%{public}s',
        this.formManagerId, this.isEnterFormManager, this.isEnterFormEdit);
      this.destroyCompanionComponent(GET_MANAGE_ERROR);
      return;
    }

    TraceUtil.traceOnce(DomainName.SCB, 'getManageFormIcon');
    AppStorage.setOrCreate('formIndexFormManageAllowShow', false);
    this.getManageFormSnapshot(this.formManagerId);
    // setTimeout(() => {
    //   this.getManageFormSnapshot(this.formManagerId, true);
    // }, DELAY_TIME);
  }

  private getManageFormItemId(manageIndex: number): string {
    return `FormManagerPanel_ManageFormItem_${manageIndex}`;
  }

  private delayReleasePixmap(pixmap: image.PixelMap | undefined, delay: number): void {
    if (!CheckEmptyUtils.isEmpty(pixmap)) {
      let releasePixmap: image.PixelMap = pixmap as image.PixelMap;
      setTimeout(() => { releasePixmap.release(); }, delay);
    }
  }

  private getFormSnapshotFromResourceManager(): void {
    let formItemId: string = FormCommonUtil.getFormComponentId(this.manageFormItem);
    this.manageFormIcon = ResourceManager.getInstance().getCachedCardSnapshot(formItemId);
  }

  private getFormSnapshotById(manageFormItemId: string, retry: boolean = false): void {
    try {
      componentSnapshot.get(manageFormItemId)?.then((pixmap: image.PixelMap) => {
        log.showInfo('getManageFormSnapshot componentSnapshot finish');
        this.delayReleasePixmap(this.manageFormIcon, 10);
        this.manageFormIcon = pixmap;
        if (retry) {
          setTimeout(() => {
            this.getManageFormSnapshot(manageFormItemId);
          }, DELAY_TIME);
        }
      }).catch((error:Error) => {
        log.error('getAllFormsInfo error', error);
      });
    } catch (error) {
      log.error('getManageFormSnapshot componentSnapshot error', error);
    }
  }

  private getManageFormSnapshot(manageFormItemId: string, retry: boolean = false): void {
    if (!this.isEnterFromApp) {
      this.getFormSnapshotFromResourceManager();
      this.manageFormOpacity = 1;
    } else {
      this.getFormSnapshotById(manageFormItemId, retry);
    }
  }

  private calculateFinalSize(cardDimension: number): void {
    this.finalWidth = FormCenterViewModel.getInstance().getFormDisplaySize(cardDimension, true);
    this.finalHeight = FormCenterViewModel.getInstance().getFormDisplaySize(cardDimension, false);
    this.scaleTempX = this.initWidth === 0 ? 1 : this.finalWidth / this.initWidth;
    this.scaleTempY = this.initHeight === 0 ? 1 : this.finalHeight / this.initHeight;
  }

  private onMenuClick(): void {
    this.formManagerShowFrom = FormCenterViewManager.getInstance().getOpenAddFormViewSource();
    log.showWarn(`enter formManager from ${this.formManagerShowFrom}`);
    if (!this.isSupportFrom() || CheckEmptyUtils.isEmpty(this.manageFormItem.bundleName) ||
      (!this.isEnterFormManager && !this.isEnterFormEdit)) {
      log.showInfo('bundleName=%{public}s, isEnterFormManager=%{public}s, isEnterFormEdit=%{public}s',
        this.manageFormItem.bundleName, this.isEnterFormManager, this.isEnterFormEdit);
      return;
    }
    this.isEnterFromApp = this.formManagerShowFrom === FormConstants.FORM_MANAGER_SHOW_FROM_DESKTOP_APP_RIGHT_MENU ||
      this.formManagerShowFrom === FormConstants.FORM_MANAGER_SHOW_FROM_RECENT_APP_RIGHT_MENU;
    // 判断是否是adaptive图标
    if (this.isEnterFromApp) {
      this.updateIconInfo();
      this.getInitSizeFromApp();
    } else {
      this.getInitSizeFromForm();
    }
    this.showEnterFormManager();
  }

  private getInitSizeFromForm(): void {
    if (this.formManagerShowFrom !== FormConstants.FORM_MANAGER_SHOW_FROM_DESKTOP_FORM_RIGHT_MENU) {
      return;
    }

    if (this.manageFormItem.isTransparent) {
      this.backBoardColor = $r('app.color.transparent_form_background_color');
    } else {
      this.backBoardColor = $r('app.color.normal_form_background_color');
    }
    let formItemId: string = FormCommonUtil.getFormComponentId(this.manageFormItem);
    let iconRectInfo: RectInfo = ItemUtils.getRectById(formItemId);
    this.getInitSize(iconRectInfo);
    this.formIcon = ResourceManager.getInstance().getCachedCardSnapshot(formItemId);
  }

  private async getInitSizeFromApp(): Promise<void> {
    let itemInfo: AppItemInfo = new AppItemInfo();
    let isRecentApp: boolean = this.formManagerShowFrom === FormConstants.FORM_MANAGER_SHOW_FROM_RECENT_APP_RIGHT_MENU;
    itemInfo.bundleName = this.manageFormItem.bundleName;
    itemInfo.appIconId = Number(this.manageFormItem.appIconId);
    itemInfo.moduleName = this.manageFormItem.moduleName;
    itemInfo.abilityName = this.manageFormItem.abilityName;
    itemInfo.areaType = this.manageFormItem.areaType;
    // 只有主应用支持卡片，index默认为0
    itemInfo.appIndex = 0;
    const isOpenFolder: boolean = FolderManager.getInstance().isFolderOpen();
    let iconId: string =
      AppIconModel.getInstance()
        .getIconId(itemInfo, isRecentApp ? String(itemInfo.appIconId) : undefined, undefined, isOpenFolder);
    let iconRectInfo: RectInfo = ItemUtils.getRectById(iconId);
    this.getInitSize(iconRectInfo);
    log.showInfo(`onFormManageShow iconRectInfo from icon ${iconId}`);
  }

  private isExistIcon(iconRectInfo: RectInfo): boolean {
    return iconRectInfo && iconRectInfo.right !== iconRectInfo.left && iconRectInfo.bottom !== iconRectInfo.top;
  }

  private getInitSize(iconRectInfo: RectInfo): void {
    if (!iconRectInfo) {
      return;
    }
    this.initCenterX = (iconRectInfo.left as number + iconRectInfo.right as number) / 2;
    this.initCenterY = (iconRectInfo.top as number + iconRectInfo.bottom as number) / 2;

    this.initWidth = iconRectInfo.right - iconRectInfo.left;
    this.initHeight = iconRectInfo.bottom - iconRectInfo.top;
  }

  @Styles
  normalStyle() {
    .position({
      x: this.initCenterX - this.finalWidth / 2,
      y: this.initCenterY - this.finalHeight / 2,
    })
    .translate({
      x: this.translateX,
      y: this.translateY
    })
    .size({ width: this.finalWidth, height: this.finalHeight })
    .borderRadius(this.companionRadius)
    .clip(true)
  }

  @Styles
  shadowStyle() {
    .shadow(this.manageFormItem.bundleName === CommonConstants.THEME_MANAGER_BUNDLE ? null :
      {
        radius: $r('app.float.normal_form_manager_radius'),
        color: this.formShadowColor,
        offsetY: $r('app.float.normal_form_manager_offset')
      })
    .overlay(this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK &&
      this.manageFormItem.bundleName !== CommonConstants.THEME_MANAGER_BUNDLE ?
      FormInLineBorder.buildView()?.builder({
        borderRadius: this.companionRadius,
      }) : null)
  }

  @Builder
  adaptiveAppForegroundImage() {
    Image(this.foreground)
      .draggable(false)
      .objectFit(ImageFit.Fill)
      .position({
        x: this.initCenterX - this.initWidth * ADAPTIVE_ICON_FACTOR / 2,
        y: this.initCenterY - this.initHeight * ADAPTIVE_ICON_FACTOR / 2,
      })
      .translate({
        x: this.translateX,
        y: this.translateY
      })
      .scale({
        x: this.foregroundScale,
        y: this.foregroundScale
      })
      .size({ width: this.initWidth * ADAPTIVE_ICON_FACTOR, height: this.initHeight * ADAPTIVE_ICON_FACTOR })
      .clip(true)
      .opacity(this.formOpacity)
  }

  @Builder
  adaptiveAppBackgroundImage() {
    Column() {
      Image(this.bgImage)
        .draggable(false)
        .objectFit(ImageFit.Fill)
        .size({
          width: this.finalWidth,
          height: this.finalHeight
        })
        .borderRadius(this.companionRadius)
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .scale({ x: this.finalScaleX, y: this.finalScaleY })
    .normalStyle()
    .opacity(this.formOpacity)
  }

  build() {
    if (this.isCompanionShow) {
      Stack() {
        Column() {
        }
        .normalStyle()
        .scale({ x: this.finalScaleX * this.backScale, y: this.finalScaleY * this.backScale })
        .opacity(this.backgroundOpacity)
        .backgroundColor(this.backBoardColor)
        .borderRadius(this.backgroundRadius)

        if (this.isEnterFromApp) {
          if (this.isAdaptiveIcon) {
            this.adaptiveAppBackgroundImage();
            this.adaptiveAppForegroundImage();
          } else {
            if (this.appIcon) {
              Image(this.appIcon)
                .draggable(false)
                .scale({ x: this.finalScaleX, y: this.finalScaleY })
                .normalStyle()
                .opacity(this.formOpacity)
                .autoResize(false)
                .interpolation(ImageInterpolation.Medium)
            }
          }
        } else {
          if (this.formIcon) {
            Image(this.formIcon)
              .draggable(false)
              .objectFit(ImageFit.Fill)
              .normalStyle()
              .scale({ x: this.finalScaleX, y: this.finalScaleY })
              .autoResize(false)
              .interpolation(ImageInterpolation.Medium)
              .opacity(this.formOpacity)
          }
        }
        Image(this.manageFormIcon)
          .draggable(false)
          .objectFit(ImageFit.Fill)
          .scale({ x: this.finalScaleX, y: this.finalScaleY })
          .normalStyle()
          .opacity(this.manageFormOpacity)
          .shadowStyle()
          .autoResize(false)
          .interpolation(ImageInterpolation.Medium)
      }
      .zIndex(1)
      .height(FormStyleConstants.DEFAULT_LAYOUT_PERCENTAGE)
      .width(FormStyleConstants.DEFAULT_LAYOUT_PERCENTAGE)
      .hitTestBehavior(this.behaviorTransparent ? HitTestMode.Transparent : HitTestMode.Default)
    }
  }
}

@Component
export struct FormCreateAnimationComponent {
  @StorageLink('screenWidth') screenWidth: number = 0;
  @StorageLink('screenHeight') screenHeight: number = 0;
  @StorageLink('createCardType') createCardType: number = FormStyleConstants.CREATE_CARD_BY_BUTTON;
  @State startAnimate: boolean = false;
  @State animateScale: number = 0;
  @State translateX: number = 0;
  @State translateY: number = 0;
  @State animateOpacity: number = 1;
  @State backgroundOpacity: number = 0;
  @State enableBlurBackground: boolean = false;
  @State objectFit: ImageFit = ImageFit.Fill;
  private mFormBorderRadius: number = 0;
  private mPosition: Position = { x: 0, y: 0 };
  private startCenterX: number = 0;
  private startCenterY: number = 0;
  private formItemWidth: number = 0;
  private formItemHeight: number = 0;
  private desktopContext: ServiceExtensionContext = GlobalContext.getContext();
  private imageCacheKey: string = '';
  private createFormFinish: boolean = false;
  private formInfo: CardItemInfo = new CardItemInfo();
  private createFormResult: boolean = false;
  private mViewStateChangeCallback?: ViewCallback;
  private gravityAnimTimeoutId?: number;
  private formShortcutBundleName: string = '';
  private shortcutFormSize: number = 0;
  private shortcutFormRadius: number = 0;

  aboutToAppear() {
    this.desktopContext?.eventHub.on(FormConstants.EVENTHUB_FORM_MANAGER_CREATE_FORM,
      (formInfo: CardItemInfo, dropPosition?: number[], dragItemType?: number, cacheKey?: string) => {
        this.shortcutFormSize = FormViewModel.getInstance().getShortcutFormSize();
        this.shortcutFormRadius = FormViewModel.getInstance().getShortcutFormRadius();
        this.onFormManageCreateForm(formInfo, dropPosition, dragItemType, cacheKey);
      });
    this.desktopContext?.eventHub.on(FormConstants.EVENTHUB_FORM_MANAGER_CREATE_FORM_RESULT,
      (formInfo: CardItemInfo, result: boolean) => {
        log.showWarn('event EVENTHUB_FORM_MANAGER_CREATE_FORM_RESULT');
        this.enableBlurBackground = FormCommonUtil.getEnableBlurBackground(formInfo);
        if (this.startAnimate) {
          this.doCreateFormAnimation(formInfo, result);
        } else {
          this.formInfo = formInfo;
          this.createFormResult = result;
          this.createFormFinish = true;
          log.showInfo('Animate do not start');
        }
      });
  }

  aboutToDisappear(): void {
    this.desktopContext?.eventHub.off(FormConstants.EVENTHUB_FORM_MANAGER_CREATE_FORM);
    this.desktopContext?.eventHub.off(FormConstants.EVENTHUB_FORM_MANAGER_CREATE_FORM_RESULT);
  }

  // 显示本页面必须通过此接口控制,避免外部业务流程不闭环导致页面阻塞桌面事件
  private showAnimateComponent(): void {
    log.showInfo('showAnimateComponent');
    this.mViewStateChangeCallback?.onShow?.(TAG);
    this.startAnimate = true;
    this.desktopContext?.eventHub.on(CommonConstants.CANCEL_ADD_FORM_ANIMATION, this.cancelAnimation);
    setTimeout(() => {
      if (this.startAnimate) {
        log.showWarn('component close by self');
        this.doClear();
      }
    }, 2000);
  }

  private onFormManageCreateForm(formInfo: CardItemInfo,
    dropPosition?: number[], dragItemType?: number, cacheKey?: string) {
    log.showInfo('onFormManageCreateForm');
    this.createFormResult = false;
    this.createFormFinish = false;
    if (formInfo.cardDimension === CommonConstants.CARD_DIMENSION_4x4 &&
      !launcherStatusUtil.getShowOutLauncherStatus()) {
      this.objectFit = ImageFit.Cover;
    }
    if (!formInfo || (!formInfo.cardId && this.isRealCard(formInfo)) ||
      isNaN(formInfo.cardDimension)) {
      log.showWarn('invalid form info');
      return;
    }
    let formItem: CardItemInfo[] = AppStorage.get('formItem') as CardItemInfo[];
    if ((!formItem || formItem.length === 0) && !dropPosition) {
      log.showWarn('onFormManageCreateForm para error');
      return;
    }
    if(this.isRealCard(formInfo)) {
      AppStorage.setOrCreate('createFormId', formInfo.cardId);
      this.imageCacheKey = cacheKey ? cacheKey : `${formInfo.cardId}${formInfo.bundleName}${formInfo.moduleName}`;
    } else {
      AppStorage.setOrCreate('createFormShortcutId', formInfo.shortcutInfo?.id);
      this.formShortcutBundleName = formInfo.bundleName;
      // 给图标组件发送createFormShortcutId变化事件
      if (this.formShortcutBundleName === CommonConstants.SCENEBOARD_BUNDLE) {
        localEventManager.sendLocalEvent(`createFormShortcutEvent_${formInfo.bundleName}`, [formInfo.shortcutInfo?.id]);
      }
      this.imageCacheKey = `shortcut_${formInfo.bundleName}_${formInfo.shortcutInfo?.id}`;
    }
    log.showWarn('cacheKey: %{public}s row: %{public}d column: %{public}d',
      this.imageCacheKey, formInfo.row, formInfo.column);
    this.startCenterX = dropPosition ? dropPosition[0] : this.screenWidth / 2;
    this.startCenterY = dropPosition ? dropPosition[1] : this.getPositionY(formItem);
    if (!this.isRealCard(formInfo)) {
      this.formItemWidth = this.shortcutFormSize;
      this.formItemHeight = this.shortcutFormSize;
    } else {
      this.formItemWidth =
        FormViewModel.getInstance().getFormStyleConfig().mFormWidth.get(String(formInfo.cardDimension)) as number;
      this.formItemHeight =
        FormViewModel.getInstance().getFormStyleConfig().mFormHeight.get(String(formInfo.cardDimension)) as number;
    }
    this.mPosition.x = this.startCenterX - this.formItemWidth / 2;
    this.mPosition.y = this.startCenterY - this.formItemHeight / 2;
    this.translateX = 0;
    this.translateY = 0;
    if (formInfo.cardDimension === CommonConstants.CARD_DIMENSION_4x4) {
      let card4x4HeightInner: number = FormUtil.get4x4CardHeight();
      this.formItemHeight = card4x4HeightInner;
    }
    this.animateScale = FormUtil.getAnimateScale(formInfo.cardDimension);
    if ((AppStorage.get('dragItemType') as number) === CommonConstants.DRAG_FROM_FORM_SERVICE) {
      this.animateScale = 1;
    }
    this.mFormBorderRadius = FormUtil.getManagerFormRadius(formInfo.cardDimension);
    if (!this.isRealCard(formInfo)) {
      this.mFormBorderRadius = this.shortcutFormRadius;
    }
    if (dragItemType !== undefined) {
      this.animateScale *= 1.1;
    }
    if (formInfo.isTransparent && this.createCardType === FormStyleConstants.CREATE_CARD_BY_BUTTON) {
      this.backgroundOpacity = 1;
      log.showInfo('isTransparent');
    }
    log.showInfo('radius: %{public}d', this.mFormBorderRadius);
    performanceMonitor.begin(FormConstants.FORM_MANAGER_CREATE_FORM, performanceMonitor.ActionType.LAST_UP);
    TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_FORM_MANAGER_CREATE_FORM_ANI);
    this.showAnimateComponent();
    if (this.createFormFinish) {
      log.showInfo('create form finished');
      this.doCreateFormAnimation(this.formInfo, this.createFormResult);
    }
  }

  /**
   * 判断是否是卡片做动效
   * @param formItem
   * @returns boolean
   */
  private isRealCard(formItem: CardItemInfo): boolean {
    return CheckEmptyUtils.isEmpty(formItem.shortcutInfo);
  }

  private getPositionY(formItem: CardItemInfo[]): number {
    let defaultDistance: number = FormStyleConstants.FORM_SERVICE_MARGIN_HORIZONTAL +
    FormStyleConstants.FORM_MGR_ADD_TO_DESKTOP_BUTTON_HEIGHT + FormStyleConstants.FORM_MANAGER_BUTTON_MARGIN_BOTTOM;

    if (formItem.length > 1) {
      return this.screenHeight - (defaultDistance + FormStyleConstants.FORM_MANAGER_SWIPER_HEIGHT / 2 +
      FormStyleConstants.FORM_MANAGER_SWIPER_INDICATOR_HEIGHT);
    } else {
      return this.screenHeight - (defaultDistance + FormStyleConstants.FORM_MANAGER_SWIPER_HEIGHT / 2 +
        FormStyleConstants.FORM_MANAGER_SWIPER_INDICATOR_HEIGHT / 2 +
      FormStyleConstants.FORM_MANAGER_SINGLE_FORM_OFFSETY);
    }
  }

  private doClear() {
    this.desktopContext?.eventHub.off(CommonConstants.CANCEL_ADD_FORM_ANIMATION, this.cancelAnimation);
    log.showInfo(`clear animation info this.imageCacheKey: ${this.imageCacheKey}`);
    performanceMonitor.end(FormConstants.FORM_MANAGER_CREATE_FORM);
    TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_FORM_MANAGER_CREATE_FORM_ANI);
    AppStorage.setOrCreate('createFormId', '');
    AppStorage.setOrCreate('createFormShortcutId', '');
    if (this.formShortcutBundleName === CommonConstants.SCENEBOARD_BUNDLE) {
      localEventManager.sendLocalEvent(`createFormShortcutEvent_${this.formShortcutBundleName}`);
    }
    this.formShortcutBundleName = '';
    this.startAnimate = false;
    this.mViewStateChangeCallback?.onHide?.(TAG);
    this.animateOpacity = 1;
    ResourceManager.getInstance().getCachedCardSnapshot(this.imageCacheKey)?.release();
    ResourceManager.getInstance().deleteAppResourceCache(this.imageCacheKey, 'cardSnapshot');
    this.imageCacheKey = '';
    this.formInfo = new CardItemInfo();
    this.createFormResult = false;
    this.createFormFinish = false;
    this.shortcutFormSize = 0;
    this.shortcutFormRadius = 0;
    if (this.gravityAnimTimeoutId != undefined) {
      log.showInfo(`cancel gravity animation. id:${this.gravityAnimTimeoutId}`);
      clearTimeout(this.gravityAnimTimeoutId);
      this.gravityAnimTimeoutId = undefined;
    }
  }

  private disappearAnimate(): void {
    AppStorage.setOrCreate('createFormId', '');
    animateTo({
      duration: 250,
      onFinish: () => {
        this.doClear();
      }
    }, () => {
      this.animateOpacity = 0;
    })
  }

  private triggerGravityAnimation(formInfo: CardItemInfo, position: number[]): void {
    const pageIndex = formInfo.page as number;
    const size = formInfo.area as number[];
    GravityAnimationManager.getInstance()
      .run(SwiperLoadData.getInstance().getSwiperKeyByIndex(pageIndex),
        position[0], position[1],
        ForceType.REPULSION, size);
  }

  private setFallPositionIfInEditMode(fallPosition: number[], cardDimension: number, isShortcutForm: boolean) {
    if (editModeManager.isInEditMode()) {
      // 由于编辑模式下卡片尺寸缩小了，所以中心点fallPosition需要偏移进行适配
      const formStyleConfig: FormStyleConfig = FormViewModel.getInstance().getFormStyleConfig();
      let cardWidth: number = 0;
      let cardHeight: number = 0;
      if (isShortcutForm) {
        cardWidth = this.shortcutFormSize;
        cardHeight = this.shortcutFormSize;
      } else {
        cardWidth = Number(formStyleConfig.mFormWidth.get(String(cardDimension)));
        cardHeight = Number(formStyleConfig.mFormHeight.get(String(cardDimension)));
      }
      fallPosition[0] += cardWidth * (1 - EditModeUtils.getDesktopScale()) / 2;
      fallPosition[1] += cardHeight * (1 - EditModeUtils.getDesktopScale()) / 2;
    }
  }

  private cancelAnimation = ():void => {
    this.doClear();
  }

  private doCreateFormAnimation(formInfo: CardItemInfo, result: boolean) {
    log.showInfo(`doCreateFormAnimation ${result}`);
    if (!result) {
      this.doClear();
      return;
    }
    let fallPosition: number[] = GridLayoutUtil.getIconCenterPosition(formInfo.row, formInfo.column, formInfo.area,
      formInfo.page);
    this.gravityAnimTimeoutId = setTimeout(() => {
      this.gravityAnimTimeoutId = undefined;
      this.triggerGravityAnimation(formInfo, fallPosition);
    }, GravityAnimationConfig.getDelayOnDrop());
    const isShortcutForm: boolean = !this.isRealCard(formInfo)
    this.setFallPositionIfInEditMode(fallPosition, formInfo.cardDimension, isShortcutForm);
    let translateTempX: number = fallPosition[0] - this.startCenterX;
    let translateTempY: number = fallPosition[1] - this.startCenterY;
    log.showWarn('page: %{public}d, fallPosition:[%{public}d, %{public}d] translateX:%{public}d translateY:%{public}d',
      formInfo.page, fallPosition[0], fallPosition[1], translateTempX, translateTempY);
    animateTo(
      {
        duration: 350,
        curve: curves.cubicBezier(0.57, 0.00, 0.71, 1.00),
        onFinish: () => {
          log.showInfo('first scale step end');
          animateTo(
            {
              delay: 50,
              curve: curves.springMotion(0.468, 0.63, 0),
              onFinish: () => {
                log.showInfo('scale step end')
                this.doClear();
              }
            }, () => {
            if (formInfo.isTransparent && this.createCardType === FormStyleConstants.CREATE_CARD_BY_BUTTON) {
              this.backgroundOpacity = 0;
            }
            this.animateScale = 1.0;
          })
        }
      }, () => {
      if (formInfo.isTransparent && this.createCardType === FormStyleConstants.CREATE_CARD_BY_BUTTON) {
        this.backgroundOpacity = 0.3;
      }
      this.animateScale = 1.1;
    })
    animateToImmediately({
      curve: curves.springMotion(0.468, 0.82, 0),
      onFinish: () => {
        log.showInfo('addFormAnimation end');
      }
    }, () => {
      if (isShortcutForm) {
        this.formItemHeight = this.shortcutFormSize;
      } else {
        this.formItemHeight =
          FormViewModel.getInstance().getFormStyleConfig().mFormHeight.get(String(formInfo.cardDimension)) as number;
      }
      this.translateX = translateTempX;
      this.translateY = translateTempY;
    });
  }

  @Styles
  normalStyle() {
    .position(this.mPosition)
    .translate({
      x: this.translateX,
      y: this.translateY
    })
    .scale({
      x: this.animateScale,
      y: this.animateScale
    })
    .size({
      width: EditModeUtils.convertWithDesktopScale(this.formItemWidth),
      height: EditModeUtils.convertWithDesktopScale(this.formItemHeight)
    })
    .borderRadius(EditModeUtils.convertWithDesktopScale(this.mFormBorderRadius))
    .clip(true)
  }

  @Styles
  shortcutShadowStyle() {
    .shadow(this.isRealCard(this.formInfo) ? null : {
      radius: StyleConstants.APP_ICON_SHADOW_RADIUS,
      color: StyleConstants.APP_ICON_SHADOW_COLOR,
      offsetY: StyleConstants.APP_ICON_SHADOW_OFFSETY
    })
  }

  build() {
    if (this.startAnimate) {
      Stack() {
        Column() {
        }
        .normalStyle()
        .backgroundColor($r('app.color.transparent_form_background_color'))
        .opacity(this.backgroundOpacity)
        if (this.enableBlurBackground) {
          Column()
            .normalStyle()
            .backgroundColor($r(`app.color.app_form_back_board`))
        }
        Image(ResourceManager.getInstance().getCachedCardSnapshot(this.imageCacheKey))
          .draggable(false)
          .objectFit(this.objectFit)
          .normalStyle()
          .syncLoad(true)
          .opacity(this.animateOpacity)
          .autoResize(false)
          .interpolation(ImageInterpolation.Medium)
          .shortcutShadowStyle()
      }
      .zIndex(1)
      .height(FormStyleConstants.DEFAULT_LAYOUT_PERCENTAGE)
      .width(FormStyleConstants.DEFAULT_LAYOUT_PERCENTAGE)
    }
  }
}