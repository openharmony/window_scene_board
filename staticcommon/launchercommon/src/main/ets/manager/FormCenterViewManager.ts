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

import bundleManager from '@ohos.bundle.bundleManager';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { VisualEffectConstants } from '@ohos/commonconstants';
import { Position } from '@kit.ArkUI';
import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { launcherStatusUtil } from '@ohos/windowscene';
import { CurrentMemScene, PerformanceReporter } from '@ohos/frameworkcommon';
import {
  ViewController,
  ViewType,
  ReportDomain,
  viewMgrPolicy,
  HiSysReportEvent,
  DeviceHelper,
} from '@ohos/frameworkwrapper';
import { CardItemInfo } from '../bean/CardItemInfo';
import { CommonConstants, DesktopMode } from '../constants/CommonConstants';
import {
  AppItemInfo,
  editModeManager,
  FormHiSysEventReporter,
  FormModel,
  GridLayoutItemInfo,
  HiEditModeDataExitType,
  MultiSelectManager
} from '../TsIndex';
import { FormEditViewManager } from './FormEditViewManager';

const TAG = 'FormCenterViewManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export enum FormDisplayType {
  DESKTOP_CARD = 0,
  SCREEN_LOCK_CARD
}
// 元服务or应用拉起卡片管理打点事件
const RESOURCE_LIB_INTO_FORM_MANAGER: string = 'RESOURCE_LIB_INTO_FORM_MANAGER';
const ATOMIC_SERVICE: string = 'atomic';
const APP: string = 'app';
class ReportParams {
  public static readonly PACKAGE_NAME: string = 'com.ohos.sceneboard';
  public static readonly PROCESS_NAME: string = 'sceneBoard';
}

export enum CardAddType {
  OTHERS = 0, // 其它场景
  RESOURCE_LIB_FORM_APP_INTO_FORM_MANAGER, // 卡片中心卡片列表进入卡片管理界面
  SHORTCUT_MENU_INTO_FORM_MANAGER, // 应用图标或卡片快捷菜单进入卡片管理界面
  RESOURCE_LIB_GRID_FORM, // 拖动卡片中心推荐卡片到桌面
  RESOURCE_LIB_GRID_FORM_INTO_FORM_MANAGER, // 卡片中心推荐卡片进入更多服务卡片界面
  AA_CARD, // 拖动负一屏卡片到桌面
  AA_CARD_SHORTCUT_MENU_INTO_FORM_MANAGER, // 长按负一屏卡片进入更多服务卡片界面
  RESOURCE_LIB_FORM_SEARCH, // 通过卡片中心搜索进入卡片管理界面
  ATOMIC_SERVICE, // 元服务进入卡片管理界面
  APP, // app进入卡片管理界面
}

export class FormCenterViewParam {
  // 展示卡片类型
  public formDisplayType: FormDisplayType = 0;
  // 是否打开0级控件
  public openHighIndexView: boolean = false;
  // 打开卡片服务界面的应用包名
  public bundleName?: string;
  // 打开卡片管理界面的卡片信息
  public formInfo?: CardItemInfo;
  // 设定卡片中心高度
  public viewHeight?: number;
  // 设定卡片中心支持最大高度
  public viewMaxHeight?: number;
  // 设置是否支持拖拽
  public isSupportDrag: boolean = true;
  // 设置是否支持一镜到底动效
  public isSupportCreateAnimate: boolean = true;
  // 设置卡片中心入口位置
  public entrancePosition: FormCenterLocation | undefined = undefined;
  // 设置双按钮布局，同时展示添加至桌面、添加至负一屏（元服务面板拉起卡片管理场景）
  public isAsdeOpen: boolean = false;
  // 负一屏拉起卡片中心
  public isNegativeScreenOpen: boolean = false;
  // 自定义网格宽度
  public customGridWidth?: number;
  // 模板卡列表
  public templateCardList?: TemplateCardInfo[];
  // 拉起主题详情页id
  public themeDetailId?: string;
  // 卡片中心拉起位置
  public location: string = FormCenterLocation.DESKTOP;
}

export class TemplateCardInfo {
  public label: string = '';
  public description: string = '';
  public dimension: number = 0;
  public formData: string = '';
}

export interface FormCenterViewController {
  showView: (param: FormCenterViewParam) => void;
  hideView: (height?: number) => void;
  closeView: () => void;
  getViewState: () => boolean;
  backGestureHandler: () => void;
  recoveryDefaultHeight?: () => void;
  closeViewSendToTheme?:() => void;
}

export enum FormCenterLocation {
  DESKTOP = 'desktop',
  NEGATIVE_SCREEN = 'negativeScreen',
  SCENE_PANEL = 'scenePanel',
  SCREEN_LOCK = 'screenLock',
  DESKTOP_B_SIDE = 'desktop_b_side',
  DESKTOP_C_SIDE = 'desktop_c_side'
}

const DESKTOP_INDEX: number = 2;
const NEGATIVE_SCREEN_INDEX: number = 5;
const SCENE_PANEL_INDEX: number = 101;
const SCREEN_LOCK_INDEX: number = 2002;

const zIndexMap: Map<string, number> = new Map([
  [FormCenterLocation.DESKTOP, DESKTOP_INDEX],
  [FormCenterLocation.NEGATIVE_SCREEN, NEGATIVE_SCREEN_INDEX],
  [FormCenterLocation.SCENE_PANEL, SCENE_PANEL_INDEX],
  [FormCenterLocation.SCREEN_LOCK, SCREEN_LOCK_INDEX]
]);

/**
 * 界面管理类：用于跳转界面.
 */
export class FormCenterViewManager {
  private static mInstance: FormCenterViewManager;
  private formCenterViewController: FormCenterViewController | null = null;
  private formManagerViewController: FormCenterViewController | null = null;
  private themeDetailViewController: FormCenterViewController | null = null;
  private addFormViewTrackSource: number = 0;

  // 是否在执行进入卡片中心的动效
  private isInFormEnterAnimate: boolean = false;
  private calculateFormCenterPositionCallback: Function | undefined = undefined;
  private sheetOffsetCallback: Function | undefined = undefined;
  // 获取卡片入口位置
  private getEntrancePosCallback: Function | undefined = undefined;
  // 半模态禁用背景模糊
  private formCenterBlurDisable: boolean = false;
  private location: FormCenterLocation = FormCenterLocation.DESKTOP;
  private mViewController: ViewController | undefined = viewMgrPolicy.getViewController(ViewType.FORM_CENTER);

  private constructor() {
    let formCenterEffectLevel: string | undefined =
      SCBVisualEffectMgr.getFeatureParam(VisualEffectConstants.CARD_VISUAL_EFFECT_LEVEL);
    if (formCenterEffectLevel && formCenterEffectLevel === 'low') {
      this.formCenterBlurDisable = true;
    }
  }

  /**
   * 获取单实例
   *
   * @returns 实例
   */
  public static getInstance(): FormCenterViewManager {
    if (FormCenterViewManager.mInstance === undefined) {
      FormCenterViewManager.mInstance = new FormCenterViewManager();
    }
    return FormCenterViewManager.mInstance;
  }

  public setCalculateFormCenterPosition(callback: Function): void {
    this.calculateFormCenterPositionCallback = callback;
  }

  public calculateFormCenterPosition(position?: FormCenterLocation): Position | undefined {
    return this.calculateFormCenterPositionCallback?.(position);
  }

  public setSheetOffsetCallback(callback: Function): void {
    this.sheetOffsetCallback = callback;
  }

  public refreshFormCenterPosition(): void {
    this.sheetOffsetCallback?.();
  }

  public setEntrancePosCallback(callback: Function): void {
    this.getEntrancePosCallback = callback;
  }

  public getEntrancePos(layoutInfo?: AppItemInfo | GridLayoutItemInfo, position?: Position): FormCenterLocation | undefined {
    return this.getEntrancePosCallback?.(layoutInfo, position);
  }

  public registerFormCenterViewController(key: string, viewController: FormCenterViewController): void {
    log.showInfo(`${key} registerFormCenterViewController`);
    this.formCenterViewController = viewController;
  }

  public unRegisterFormCenterViewController(key: string): void {
    this.formCenterViewController = null;
  }

  public registerFormManagerViewController(key: string, viewController: FormCenterViewController): void {
    log.showInfo(`${key} registerFormManagerViewController`);
    this.formManagerViewController = viewController;
  }

  public unRegisterFormManagerViewController(key: string): void {
    this.formManagerViewController = null;
  }
  public registerThemeDetailViewController(viewController: FormCenterViewController): void {
    this.themeDetailViewController = viewController;
  }

  public unRegisterThemeDetailViewController(): void {
    this.themeDetailViewController = null;
  }

  public formCenterHomeGestureHandler(): void {
    FormEditViewManager.getInstance().formEditHomeGestureHandler();
    this.closeFormManagerView();
    this.closeFormCenterView();

    // 在桌面编辑模式中使用home键需要退出编辑模式
    if ((this.location === FormCenterLocation.DESKTOP) && editModeManager.isInEditMode() &&
      !MultiSelectManager.getInstance().getStatus().inGatherOrDragOrDrop) {
      editModeManager.changeDesktopMode(DesktopMode.NORMAL_MODE, HiEditModeDataExitType.EXIT_GESTURE);
    }
  }

  public formCenterBackGestureHandler(): void {
    if (this.isThemeDetailViewShowing()) {
      this.themeDetailViewController?.closeViewSendToTheme?.();
      return;
    }
    if (this.isFormManagerViewShowing()) {
      this.formManagerViewController?.backGestureHandler();
      return;
    }
    if (this.isFormCenterViewShowing()) {
      this.formCenterViewController?.backGestureHandler();
    }
    FormEditViewManager.getInstance().formEditBackGestureHandler();
  }

  // 设置第三方来源
  private setThirdSource(param: FormCenterViewParam): void {
    let appData = FormModel.getInstance().getAppInfoByBundleName(param.bundleName ?? '');
    // 默认是APP
    let source = CardAddType.APP;
    if (appData && appData.bundleType === bundleManager.BundleType.ATOMIC_SERVICE) {
      source = CardAddType.ATOMIC_SERVICE;
    }
    this.setOpenAddFormViewSource(source);
  }

  public openFormCenterView(param?: FormCenterViewParam): void {
    let params: FormCenterViewParam = param ?? new FormCenterViewParam();
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      params.viewHeight = CommonConstants.OUTER_EDIT_HALF_MODE_DEFAULT_HEIGHT;
    }
    PerformanceReporter.getInstance().reportEnterMemScene(CurrentMemScene.SCENE_FORM_CENTER);
    log.showWarn(`openFormCenterView location: ${params.location}, formDisplayType: ${params.formDisplayType}`);
    if (params.formDisplayType === FormDisplayType.SCREEN_LOCK_CARD) {
      params.location = FormCenterLocation.SCREEN_LOCK;
    }
    this.setViewZIndex(params.location as FormCenterLocation);
    if (params.openHighIndexView) {
      // 第三方拉起卡片中心
      this.setThirdSource(params);
    }
    this.formCenterViewController?.showView(params);
  }

  public hideFormCenterView(height?: number): void {
    if (this.formCenterViewController?.getViewState()) {
      this.formCenterViewController.hideView(height);
    }
  }

  public recoveryFormCenterHeight(): void {
    log.showInfo('recoveryFormCenterHeight');
    if (this.formCenterViewController?.getViewState()) {
      this.formCenterViewController.recoveryDefaultHeight?.();
    }
  }

  public getFormCenterLocation(): FormCenterLocation {
    return this.location;
  }

  public closeFormCenterView(): void {
    PerformanceReporter.getInstance().reportExitMemScene(CurrentMemScene.SCENE_FORM_CENTER);
    log.showWarn('closeFormCenterView');
    if (this.isFormManagerViewShowing()) {
      this.closeFormManagerView();
    }
    if(this.isThemeDetailViewShowing()){
      this.closeThemeDetailView();
    }
    // phone 该接口功能是关闭所有卡片半模态，PC卡片编辑页是一个自由窗口，不需要关闭
    if (FormEditViewManager.getInstance().isSheetEditView) {
      FormEditViewManager.getInstance().closeFormEditView();
    }
    if (this.formCenterViewController?.getViewState()) {
      this.formCenterViewController.closeView();
    }
  }

  public openFormManagerView(param?: FormCenterViewParam): void {
    let params: FormCenterViewParam = param ? param : new FormCenterViewParam();
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      params.viewHeight = CommonConstants.OUTER_EDIT_HALF_MODE_DEFAULT_HEIGHT;
    }
    log.showWarn(`openFormManagerView location: ${params.location}`);
    this.setViewZIndex(params.location as FormCenterLocation);
    if (params.openHighIndexView) {
      // 第三方拉起卡片管理
      this.setThirdSource(params);
      // 来源
      let source: string = this.addFormViewTrackSource === CardAddType.ATOMIC_SERVICE ? ATOMIC_SERVICE : APP;
      if (params.formInfo) {
        let mReport: iReport = this.generateReportParam(params.formInfo);
        // 打点上报数据
        HiSysReportEvent.getHiSysReportEvent(ReportDomain.FORM_UE)
          .reportBehavior(RESOURCE_LIB_INTO_FORM_MANAGER, {
            bundleName: param?.bundleName,
            PNAMEID: mReport.PNAMEID,
            PVERSIONID: mReport.PVERSIONID,
            DEVICE_TYPE: mReport.DEVICE_TYPE,
            FORM_ID: mReport.FORM_ID,
            MODULE_NAME: mReport.MODULE_NAME,
            FORM_NAME: mReport.FORM_NAME,
            CELL_SIZE: mReport.CELL_SIZE,
            source
          });
      }
    }
    this.formManagerViewController?.showView(params);
  }

  public updateZIndexOfLocation(location: FormCenterLocation, zIndex: number): void {
    log.showWarn(`update zIndex of location, zindex: ${zIndex}, location: ${location}`);
    if (!location || !zIndex) {
      return;
    }
    zIndexMap.set(location, zIndex);
  }

  private setViewZIndex(location: FormCenterLocation): void {
    let zIndex: number = zIndexMap.get(location) ?? NEGATIVE_SCREEN_INDEX;
    this.location = location ?? FormCenterLocation.DESKTOP;
    if (!this.mViewController) {
      this.mViewController = viewMgrPolicy.getViewController(ViewType.FORM_CENTER);
    }
    log.showInfo(`setViewZIndex ${zIndex}, location: ${location}, id: ${this.mViewController?.getPersistentId()}`);
    if (this.mViewController?.getZIndex() === zIndex) {
      return;
    }
    this.mViewController?.setZIndex(zIndex);
  }

  private generateReportParam(card: CardItemInfo): iReport {
    return {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DEVICE_TYPE: FormHiSysEventReporter.getDeviceType(),
      FORM_ID: card?.cardId,
      MODULE_NAME: card?.moduleName,
      FORM_NAME: card?.cardName,
      CELL_SIZE: card?.area ? card.area[0] + '*' + card.area[1] : undefined,
    };
  }

  public closeFormManagerView(onlyCloseFormManager?: boolean): void {
    log.showWarn('closeFormManagerView');
    if (!onlyCloseFormManager && FormModel.getInstance().isSupportFormCenterSplit() && this.isFormCenterViewShowing()) {
      this.closeFormCenterView();
      return;
    }
    if(this.isThemeDetailViewShowing()){
      this.closeThemeDetailView();
    }
    if (this.formManagerViewController?.getViewState()) {
      this.formManagerViewController.closeView();
    }
  }

  public openThemeDetailView(param?: FormCenterViewParam): void {
    log.showWarn('openThemeDetailView');
    if (param) {
      this.themeDetailViewController?.showView(param);
    }
  }

  public hideThemeDetailView(height?: number): void {
    if (this.themeDetailViewController?.getViewState()) {
      this.themeDetailViewController?.hideView(height);
    }
  }

  public closeThemeDetailView(): void {
    log.showWarn('closeThemeDetailView');
    if (this.themeDetailViewController?.getViewState()) {
      this.themeDetailViewController?.closeView();
    }
  }

  public isThemeDetailViewShowing(): boolean {
    return Boolean(this.themeDetailViewController?.getViewState());
  }

  public isFormCenterViewShowing(): boolean {
    if (this.formCenterViewController && this.formCenterViewController.getViewState()) {
      return true;
    }
    // 非半模态无需判断卡片编辑页是否显示
    if (!FormEditViewManager.getInstance().isSheetEditView) {
      return false;
    }
    const isFormEditViewShowing: boolean | undefined = FormEditViewManager.getInstance().isFormEditViewShowing();
    return isFormEditViewShowing;
  }

  public isFormManagerViewShowing(): boolean {
    if (this.formManagerViewController) {
      return this.formManagerViewController.getViewState();
    }
    return false;
  }

  public setOpenAddFormViewSource(source: number): void {
    log.showWarn(`setOpenAddFormViewSource: ${source}`);
    this.addFormViewTrackSource = source;
  }

  public getOpenAddFormViewSource(): number {
    log.showWarn(`getOpenAddFormViewSource: ${this.addFormViewTrackSource}`);
    return this.addFormViewTrackSource;
  }

  public setIsInFormEnterAnimate(isInAnimate: boolean): void {
    log.showInfo(`setIsInFormEnterAnimate: ${isInAnimate}`);
    this.isInFormEnterAnimate = isInAnimate;
  }

  public getIsInFormEnterAnimate(): boolean {
    log.showInfo(`getIsInFormEnterAnimate: ${this.isInFormEnterAnimate}`);
    return this.isInFormEnterAnimate;
  }

  public openFormCenterViewByNegativeScreen(param?: FormCenterViewParam): void {
    log.showInfo('openFormCenterViewByNegativeScreen');
    if (!param) {
      param = new FormCenterViewParam();
    }
    param.isNegativeScreenOpen = true;
    param.isSupportDrag = true;
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      param.viewHeight = CommonConstants.OUTER_EDIT_HALF_MODE_DEFAULT_HEIGHT;
    }
    this.setViewZIndex(FormCenterLocation.NEGATIVE_SCREEN);
    this.formCenterViewController?.showView(param);
    AppStorage.setOrCreate('showFormCenterViewByNegativeScreen', true);
  }

  public openFormManagerViewByNegativeScreen(param?: FormCenterViewParam): void {
    log.showInfo('openFormManagerViewByNegativeScreen');
    let params: FormCenterViewParam = param ? param : new FormCenterViewParam();
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      params.viewHeight = CommonConstants.OUTER_EDIT_HALF_MODE_DEFAULT_HEIGHT;
    }
    params.isNegativeScreenOpen = true;
    params.isSupportDrag = true;
    this.setViewZIndex(FormCenterLocation.NEGATIVE_SCREEN);
    this.formManagerViewController?.showView(params);
    AppStorage.setOrCreate('showFormManagerViewByNegativeScreen', true);
  }

  /**
   * 获取卡片中心背景模糊禁用状态
   * @returns true：禁用， false：不禁用
   */
  public getFormCenterBlurDisable(): boolean {
    return this.formCenterBlurDisable;
  }
}

export interface iReport {
  PNAMEID: string;
  PVERSIONID: string;
  DEVICE_TYPE: number;
  FORM_ID: string;
  MODULE_NAME: string;
  FORM_NAME: string;
  CELL_SIZE?: string;
}