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
import { CommonUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { DeviceHelper, EvtBus } from '@ohos/frameworkwrapper';
import { SCBPropertyChangeReason, SCBScreenProperty, SCBScreenSessionManager } from '@ohos/windowscene';
import { AnyClock } from '../../editsheet/models/AnyClock';
import { IDofParam } from '@ohos/screenlockcommon/src/main/ets/wallpaper/ScreenLockWallpaperManager';
import ScreenLockThemeManager, {
  CONFIG_VERSION,
  defaultThemeParam,
  SANDBOX_THEME_QUALIFIER,
  ScreenLockThemeChangeEvent,
} from './ScreenLockThemeManager';
import {
  ClockInnerConfig,
  ClockLayout,
  IThemeParam,
  LockscreenConfig,
  LockscreenForm,
  LockscreenFormConfig,
  LockscreenThemeConfig
} from '../WidgetParam';
import { Callback } from '@ohos.base';
import { DofWallpaperStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { CommonUtil } from '@ohos/screenlockcommon/src/main/ets/utils/CommonUtil';
import {
  DisplayUtils,
  GlobalStatusCache,
  ISlState,
  ScreenLockStateManager,
  SlMainStateType,
  SlObject,
  slUiStateMgr
} from '@ohos/screenlockcommon';
import { DisplayStateListener, DisplayStateManager } from '@ohos/screenlockcommon/Index';
import { ClockStaticData } from '../../clock/model/data/ClockStaticData';
import ScreenLockFormViewModel from '../../form/vm/ScreenLockFormViewModel';
import { ArrayList, HashSet } from '@kit.ArkTS';
import { clockLayoutHelper, GridAmount } from '../../clock/common/ClockLayoutHelper';
import { ThemeScene } from '@ohos/screenlockcommon/src/main/ets/constants/ThemeEditAndScreenLockConstants';
import { clockWidgetConfigManager } from '../../clock/common/ClockWidgetConfigManager';
import { Qualifier } from '@ohos/themeservicekit/Index';
import { ClockComHelper } from '../helper/ClockComHelper';
import ScreenLockFormPanelMeshConfig from '../../form/ScreenLockFormPanelMeshConfig';

export type ThemeInfo = undefined | string | number | boolean | object;

export enum DataType {
  CLOCK_STYLE
}

export interface MultiSceneThemeChangeListener {
  onThemeChanged(): void;
}

const HEX = 16;
const NONE_FLAG = 0x0000;
const DISPLAY_FOLD_MODE_FULL_FLAG = 0x0001;
const DISPLAY_FOLD_MODE_MAIN_FLAG = 0x0002;
const ORIENTATION_LANDSCAPE_FLAG = 0x0004;
const ORIENTATION_PORTRAIT_FLAG = 0x0008;
const THREE_FOLD_G_STATUS = 0x0010;
const FOLD_MODE_FLAG = DISPLAY_FOLD_MODE_FULL_FLAG | DISPLAY_FOLD_MODE_MAIN_FLAG | THREE_FOLD_G_STATUS;
const ORIENTATION_FLAG = ORIENTATION_LANDSCAPE_FLAG | ORIENTATION_PORTRAIT_FLAG;
const QUALIFIER_PRIORITY_LIST = [ThemeScene.LAND_UNFOLDED2, ThemeScene.UNFOLDED2,
  ThemeScene.LAND_UNFOLDED, ThemeScene.UNFOLDED, ThemeScene.LAND, ThemeScene.BASE];
const PAD_GRID_AMOUNT_Y: number = 10;
const PAD_GRID_AMOUNT_LAND_Y: number = 6;
const COMMON_GRID_AMOUNT_Y: number = 7;

const TAG = `MultiSceneThemeManager`;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 多场景主题管理，处理折叠机、平板的锁屏多场景主题，直板机不涉及：
 * 锁屏在不同场景下展示不同主题信息，如用户在折叠态和展开态分别编辑锁屏信息，则展示不同锁屏主题元素
 * 所有UI显示使用一份UI状态量控制显示，但每个场景的主题信息在themeInfos都有存储
 * 当场景切换时，根据切换后的场景从存储中获取对应的主题信息，用以刷新UI状态量，而不从主题中读取。
 */
export class MultiSceneThemeManager {
  // 多场景主题数据缓存 时钟、卡片、壁纸等
  private themeInfos?: Map<string, ThemeInfo>;
  // 主题信息对应的UI状态量，所有场景只有一份对象，对象变化时驱动UI刷新
  private uiThemeInfos?: Map<DataType, ThemeInfo>;
  // 在编辑器产生的临时编辑信息
  private themeInfosInEditor?: Map<string, ThemeInfo>;
  private themeChangeListener?: ArrayList<MultiSceneThemeChangeListener>;
  // 场景映射
  private sceneMap: Map<number, ThemeScene> = new Map([
  // 折叠屏折叠态不区分横竖屏, 均取base路劲
    [DISPLAY_FOLD_MODE_MAIN_FLAG | ORIENTATION_PORTRAIT_FLAG, ThemeScene.BASE],
    [DISPLAY_FOLD_MODE_MAIN_FLAG | ORIENTATION_LANDSCAPE_FLAG, ThemeScene.BASE],
    // 折叠屏展开态竖屏, 对应unfolded
    [DISPLAY_FOLD_MODE_FULL_FLAG | ORIENTATION_PORTRAIT_FLAG, ThemeScene.UNFOLDED],
    // 折叠屏展开态横屏, 对应land-unfolded
    [DISPLAY_FOLD_MODE_FULL_FLAG | ORIENTATION_LANDSCAPE_FLAG, ThemeScene.LAND_UNFOLDED],
    // 平板竖屏
    [ORIENTATION_PORTRAIT_FLAG, ThemeScene.BASE],
    // 平板横屏
    [ORIENTATION_LANDSCAPE_FLAG, ThemeScene.LAND],
    [THREE_FOLD_G_STATUS | ORIENTATION_PORTRAIT_FLAG, ThemeScene.UNFOLDED2],
    [THREE_FOLD_G_STATUS | ORIENTATION_LANDSCAPE_FLAG, ThemeScene.LAND_UNFOLDED2]
  ]);
  // 锁屏主题是否存在多场景：折叠机内外屏独立编辑生成主题、折叠机横屏美学构图生成主题、PAD横屏美学构图生成主题
  protected isMultiSceneThemeProduct = (DeviceHelper.isFoldButNotSmallFoldProduct() ||
  DeviceHelper.isPadOr2in1PcType());
  private isScreenOnEnd: boolean = AppStorage.get<boolean>('isEndScreenOn') as boolean;
  private runAfterScreenOnEnd: Callback<void> | null = null;
  // 时钟信息是否为默认，用户编辑过则为false
  private isDefaultTheme: boolean = true;
  // 场景flag
  private sceneFlags: number = NONE_FLAG;
  private scene: ThemeScene = ThemeScene.BASE;
  private formViewModel?: ScreenLockFormViewModel;

  private readonly _screenPropertyChangeCallback: DisplayStateListener = {
    onScreenPropertyChange: (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
      let hasThemeChanged = this.updateThemeForScreenPropertyChange(screenProperty, reason);
      if (hasThemeChanged) {
        let curClockParams = this.getCurSceneThemeInfo() as LockscreenThemeConfig;
        ScreenLockThemeManager.getInstance().onThemePreChange(curClockParams.clock);
        let themeChangeEvent: ScreenLockThemeChangeEvent = new ScreenLockThemeChangeEvent();
        themeChangeEvent.isDisplayChange = true;
        EvtBus.post(ScreenLockThemeChangeEvent, themeChangeEvent);
      }
    }
  };

  /**
   * 根据屏幕属性变化更新主题信息
   * @param screenProperty 更新后的屏幕属性
   * @param reason 屏幕属性变化的原因
   * @returns true表示主题发生变化，否则false
   */
  public updateThemeForScreenPropertyChange(screenProperty: SCBScreenProperty,
    reason: SCBPropertyChangeReason): boolean {
    if (CommonUtils.isInvalid(screenProperty) || !this.isMultiSceneThemeProduct) {
      log.showWarn(`updateThemeForScreenPropertyChange screenProperty:${screenProperty}`);
      return false;
    }
    let isLandscape = screenProperty.width > screenProperty.height;
    let isFolded = !clockLayoutHelper.isFullDisplayMode();
    log.showInfo(`updateThemeForScreenPropertyChange reason:${reason}, isLandscape:${isLandscape}, isFolded:${isFolded}`);
    if (DeviceHelper.isPadOr2in1PcType()) {
      this.combineRotationFlag(isLandscape);
    }
    if (DeviceHelper.isFoldButNotSmallFoldProduct()) {
      this.combineRotationFlag(isLandscape);
      this.combineFoldModeFlag(isFolded);
    }
    return this.updateSceneTheme();
  }

  init() {
    if (!this.isMultiSceneThemeProduct) {
      return;
    }
    this.uiThemeInfos = new Map();
    this.themeInfos = new Map();
    this.themeInfosInEditor = new Map();
    this.themeChangeListener = new ArrayList();
    this.initSceneFlag();
    this.initDefaultClockCacheInfo();
    DisplayStateManager.getInstance().registerObserver(this._screenPropertyChangeCallback);
  }

  destroy() {
    if (!this.isMultiSceneThemeProduct) {
      return;
    }
    this.themeInfos?.clear();
    this.uiThemeInfos?.clear();
    this.themeInfosInEditor?.clear();
    this.themeChangeListener?.clear();
    DisplayStateManager.getInstance().unRegisterObserver(this._screenPropertyChangeCallback);
  }

  protected initSceneFlag() {
    let mainScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    let isLandscape = mainScreenSession.scbScreenProperty.width > mainScreenSession.scbScreenProperty.height;
    if (DeviceHelper.isPadOr2in1PcType()) {
      this.combineRotationFlag(isLandscape);
    }
    if (DeviceHelper.isFoldButNotSmallFoldProduct()) {
      let isFolded = !clockLayoutHelper.isFullDisplayMode();
      this.combineFoldModeFlag(isFolded);
      this.combineRotationFlag(isLandscape);
    }
    this.scene = this.obtainScene(this.sceneFlags);
  }

  protected initDefaultClockCacheInfo() {
    SANDBOX_THEME_QUALIFIER.forEach((qualifier) => {
      let defaultThemeInfo: LockscreenThemeConfig = this.getDefaultThemeParams(qualifier);
      this.themeInfos?.set(qualifier, ObjectCopyUtil.deepClone(defaultThemeInfo));
    })
  }

  protected updateSceneTheme(): boolean {
    let scene = this.obtainScene(this.sceneFlags);
    log.info(`updateSceneTheme oldScene:${this.scene}, newScene:${scene}, flags:${this.sceneFlags.toString(HEX)}`);
    let hasSceneChange = this.scene !== scene;
    if (hasSceneChange) {
      let oldScene = this.scene
      this.scene = scene;
      return this.applyThemeByCache(scene, oldScene);
    }
    return false;
  }

  protected obtainScene(flag: number): ThemeScene {
    return this.sceneMap.get(flag) ?? ThemeScene.NONE;
  }

  protected combineFoldModeFlag(isFolded: boolean) {
    let foldFlag = isFolded ? DISPLAY_FOLD_MODE_MAIN_FLAG : DISPLAY_FOLD_MODE_FULL_FLAG;
    if (DeviceHelper.isThreeFoldProduct()) {
      foldFlag = DisplayUtils.isThreeFoldFStatus() ? DISPLAY_FOLD_MODE_MAIN_FLAG :
        (DisplayUtils.isThreeFoldMStatus() ? DISPLAY_FOLD_MODE_FULL_FLAG : THREE_FOLD_G_STATUS);
    }
    this.sceneFlags &= ~FOLD_MODE_FLAG;
    this.sceneFlags |= foldFlag;
  }

  protected combineRotationFlag(isLandscape: boolean) {
    let rotationFlag = isLandscape ? ORIENTATION_LANDSCAPE_FLAG : ORIENTATION_PORTRAIT_FLAG;
    this.sceneFlags &= ~ORIENTATION_FLAG;
    this.sceneFlags |= rotationFlag;
  }

  /**
   * 根据主题路劲缓存主题信息
   * @param qualifier 主题路劲限定符
   * @param infoType 缓存数据类型
   * @param themeInfo 主题信息
   * @returns
   */
  cacheThemeInfoByQualifier(themeParams: Map<Qualifier, LockscreenThemeConfig>) {
    if (!this.isMultiSceneThemeProduct) {
      return;
    }
    this.isDefaultTheme = true;
    this.themeInfos?.forEach((themeInfo: ThemeInfo, qualifier: string) => {
      let themeConfig = this.getThemeParamsByPriority(qualifier, themeParams);
      let cacheThemeInfo = themeInfo as LockscreenThemeConfig;
      if (this.isDefaultTheme) {
        this.isDefaultTheme = CommonUtil.isAllPropertyEquals(themeConfig, this.getDefaultThemeParams(qualifier));
      }
      ObjectCopyUtil.deepClone(themeConfig, cacheThemeInfo);
      log.info(`cacheThemeInfoByQualifier qualifier:${qualifier}, layout:${themeConfig.clock.layout}, ` +
        `x:${themeConfig.clock.positionX} ,y:${themeConfig.clock.positionY}, ` +
        `formSize:${themeConfig.form.list.length}, isDefaultTheme:${this.isDefaultTheme}`);
    })
  }

  updateFormPosition(formConfigs: LockscreenFormConfig[]) {
    let isInEditor: boolean = ScreenLockStateManager.getInstance().isInEdite;
    log.showInfo(`updateFormPosition isInEditor:${isInEditor}`);
    if (isInEditor) {
      return;
    }
    let themeConfigs = this.getCurSceneThemeInfo() as LockscreenThemeConfig;
    if (themeConfigs) {
      let newFormConfigs = formConfigs.map(item => ObjectCopyUtil.deepClone(item, new LockscreenFormConfig()));
      themeConfigs.form.list = newFormConfigs;
    }
  }

  initEditorThemeInfo() {
    if (!this.isMultiSceneThemeProduct) {
      return;
    }
    this.themeInfosInEditor?.clear();
    SANDBOX_THEME_QUALIFIER.forEach(qualifier => {
      let themeInfo = this.themeInfos?.get(qualifier) ?? this.getDefaultThemeParams(qualifier);
      let defaultEditorTheme = ObjectCopyUtil.deepClone(themeInfo) as LockscreenThemeConfig;
      log.showInfo(`initEditorThemeInfo qualifier:${qualifier}, layout:${defaultEditorTheme.clock.layout}, ` +
        `x:${defaultEditorTheme.clock.positionX}, y:${defaultEditorTheme.clock.positionY}`);
      this.themeInfosInEditor?.set(qualifier, defaultEditorTheme);
    })
  }

  revertThemeInfoOnExitEditor() {
    const clockStyle: AnyClock = this.uiThemeInfos?.get(DataType.CLOCK_STYLE) as AnyClock;
    const origThemeInfo: LockscreenThemeConfig = this.getCurSceneThemeInfo() as LockscreenThemeConfig;
    if (!origThemeInfo) {
      log.showInfo(`revertThemeInfoOnExitEditor origThemeInfo is null`);
      return;
    }
    let formConfigs = origThemeInfo.form.list.map(item => ObjectCopyUtil.deepClone(item, new LockscreenFormConfig()));
    this.applyClockStyleByCache(clockStyle, origThemeInfo.clock);
    if (this.formViewModel) {
      origThemeInfo.form.list = formConfigs.map(item => ObjectCopyUtil.deepClone(item, new LockscreenFormConfig()));
      this.formViewModel.initFormConfigInfo(formConfigs);
      this.formViewModel.formPanelPositionY = origThemeInfo.form.positionY;
      this.formViewModel.updatePanelHeight();
      ScreenLockFormPanelMeshConfig.setPanelHeight(this.formViewModel.getFormPanelHeight());
    }
    this.themeInfosInEditor?.clear();
  }

  updateEditorCacheThemeInfo(form: LockscreenForm, scene?: string) {
    if (!scene) {
      scene = this.getCurrentThemeQualifier();
    }
    // 更新时钟
    this.updateEditorCacheByQualifier(scene);
    let editTogether: string = this.getEditTogetherQualifier(scene);
    if (scene !== editTogether) {
      this.updateEditorCacheByQualifier(editTogether, true);
    }

    let clockObject: AnyClock = this.uiThemeInfos?.get(DataType.CLOCK_STYLE) as AnyClock;
    // 获取当前scene的卡片布局类型
    let currentClockLayout =
      (this.themeInfosInEditor?.get(scene) as LockscreenThemeConfig)?.clock.layout;
    // 多scene场景更新卡片信息，相同布局scene的卡片维持现状，不同布局scene卡片列表刷新
    this.themeInfosInEditor?.forEach((themeInfo: ThemeInfo, sceneKey: string) => {
      let newForm: LockscreenForm = ObjectCopyUtil.deepClone(form);
      let editorThemeConfig = themeInfo as LockscreenThemeConfig;
      // 更新卡片
      if (currentClockLayout === editorThemeConfig.clock.layout) {
        editorThemeConfig.form = newForm;
      } else {
        ScreenLockFormViewModel.adjustFormConfigs(editorThemeConfig.clock.layout, currentClockLayout,
          newForm.list);
        editorThemeConfig.form.list = newForm.list;
      }
    });
  }

  protected updateEditorCacheByQualifier(qualifier: string, editTogether: boolean = false) {
    let cacheEditorThemeInfo = this.themeInfosInEditor?.get(qualifier) as LockscreenThemeConfig;
    let curClockStyle = this.uiThemeInfos?.get(DataType.CLOCK_STYLE) as AnyClock;
    if (CommonUtils.isInvalid(cacheEditorThemeInfo) || CommonUtils.isInvalid(curClockStyle) ||
      !cacheEditorThemeInfo.clock) {
      log.showWarn(`updateEditorThemeInfo return for theme info is invalid`)
      return;
    }
    let cacheClock = cacheEditorThemeInfo.clock;
    if (!editTogether) {
      cacheClock.positionX = curClockStyle.x;
      cacheClock.positionY = curClockStyle.y;
    }
    log.showWarn(`updateEditorThemeInfo qualifier:${qualifier}, x:${cacheClock.positionX} ,y:${cacheClock.positionY}`);
    cacheClock.layout = curClockStyle.layout;
    cacheClock.textAlign = curClockStyle.alignment;
    cacheClock.textShadow = curClockStyle.isClockTextShadowEnabled;
    cacheClock.textBlurEffect = curClockStyle.isClockTextBlurEffectEnabled;
    cacheClock.editStatus = false;
    cacheClock.color = curClockStyle.clockStrokeColor;
    cacheClock.fontFamily = curClockStyle.clockFontFamily;
    cacheClock.aestheticColorArgs = curClockStyle.aestheticColorArgs ?? defaultThemeParam.clock.aestheticColorArgs;
    cacheClock.isLightWallpaper = curClockStyle.isLightWallpaper;
    cacheClock.signatureVisible = curClockStyle.isClockSignatureVisible;
    cacheClock.signatureText = curClockStyle.clockSignatureText;
    cacheClock.clockDegree = curClockStyle.clockDegreeNumber;
  }

  updateMultiSceneClockPosition(newLayout: ClockLayout, scene?: string) {
    if (!this.formViewModel) {
      log.showWarn('error params formViewModel is invalid!!');
      return;
    }
    if (!scene) {
      scene = this.getCurrentThemeQualifier();
    }
    let togetherClock: AnyClock = new AnyClock();
    let editTogether = this.getEditTogetherQualifier(scene);
    if (editTogether === scene) {
      log.showWarn('editTogether is same as scene.');
      return;
    }
    let editTogetherThemeInfo = this.themeInfosInEditor?.get(editTogether) as LockscreenThemeConfig;
    if (!editTogetherThemeInfo || !editTogetherThemeInfo.clock || !editTogetherThemeInfo.clock.layout) {
      log.showWarn('editTogetherThemeInfo is undefined');
      return;
    }    
    let togetherLayout = editTogetherThemeInfo.clock.layout;
    log.showInfo(`updateMultiSceneClockPosition editTogether:${editTogether}, newLayout:${newLayout},` +
      ` togetherLayout:${togetherLayout}`);
    if (newLayout === togetherLayout) {
      // 涉及同步编辑的场景应只有位置坐标不同，若同步更新的layout恰好和当前新的layout相同则不需要自适应
      log.showWarn('the togetherLayout maybe error!!');
      return;
    }
    togetherClock.x = editTogetherThemeInfo.clock.positionX;
    togetherClock.y = editTogetherThemeInfo.clock.positionY;
    togetherClock.layout = togetherLayout;
    let togetherGridAmount = clockLayoutHelper.getLayoutGridAmount(editTogether === ThemeScene.BASE);
    if (togetherClock) {
      togetherClock.clockFontFamily = clockWidgetConfigManager.getClockDefaultFontFamily(newLayout);
    }
    clockLayoutHelper.updateClockPosition(newLayout, togetherClock, togetherGridAmount,
      this.formViewModel?.getReloadFormHeight(newLayout) ?? 0,
      this.formViewModel?.getCurrentPanelHeight() ?? 0);
    editTogetherThemeInfo.clock.positionX = togetherClock.x;
    editTogetherThemeInfo.clock.positionY = togetherClock.y;
    editTogetherThemeInfo.clock.layout = newLayout;
  }

  getEditTogetherClockPosition(): AnyClock {
    let togetherClock: AnyClock = new AnyClock();
    let editTogether = this.getEditTogetherQualifier(this.getCurrentThemeQualifier());
    let editTogetherThemeInfo = this.themeInfosInEditor?.get(editTogether) as LockscreenThemeConfig;
    togetherClock.x = editTogetherThemeInfo.clock.positionX;
    togetherClock.y = editTogetherThemeInfo.clock.positionY;
    return togetherClock;
  }

  updateEditTogetherClockPosition(togetherClock: AnyClock) {
    let editTogether = this.getEditTogetherQualifier(this.getCurrentThemeQualifier());
    let editTogetherThemeInfo = this.themeInfosInEditor?.get(editTogether) as LockscreenThemeConfig;
    editTogetherThemeInfo.clock.positionX = togetherClock.x;
    editTogetherThemeInfo.clock.positionY = togetherClock.y;
  }

  getEditTogetherGridAmount(): GridAmount {
    let editTogether = this.getEditTogetherQualifier(this.getCurrentThemeQualifier());
    return clockLayoutHelper.getLayoutGridAmount(editTogether === ThemeScene.BASE);
  }

  protected getFormConfig(): LockscreenForm {
    let newFormConfig = new LockscreenForm();
    if (this.formViewModel) {
      newFormConfig.list = this.formViewModel.getFormConfigInfo();
      newFormConfig.positionY = this.formViewModel.getPanelPositionY();
    }
    return newFormConfig;
  }

  /**
   * 设置主题UI数据信息
   * @param themeInfo 控制UI刷新的主题数据信息
   */
  setupUiThemeInfo(infoType: DataType, themeInfo: ThemeInfo) {
    if (!this.isMultiSceneThemeProduct) {
      return;
    }
    this.uiThemeInfos?.set(infoType, themeInfo);
  }

  setFormViewModel(formViewModel: ScreenLockFormViewModel | undefined) {
    this.formViewModel = formViewModel;
  }

  /**
   * 获取当前主题的路劲限定符
   * @returns
   */
  getCurrentThemeQualifier(): string {
    if (!this.isMultiSceneThemeProduct) {
      return ThemeScene.BASE;
    }
    let scene = this.obtainScene(this.sceneFlags);
    log.info(`getCurrentThemeQualifier flags:${this.sceneFlags.toString(HEX)}, scene:${scene}`);
    return scene;
  }

  /**
   * 得到对应的场景dof配置项
   */
  public getDofParamByScene(): IDofParam | undefined {
    const scene = this.getCurrentThemeQualifier();
    const dofWallPaperState: ISlState | undefined =
      slUiStateMgr.getSlState(SlMainStateType.SL_DOF_WALLPAPER_STATIC_STATE);
    const config: SlObject =
      dofWallPaperState?.getSlState(DofWallpaperStaticStateType.DOF_TYPE_CONFIG);
    return (config as Map<string, IDofParam> | undefined)?.get(scene);
  }

  /**
   * 获取需要同步写入的关联路劲限定符。
   * 如折叠机展开态或平板的横屏和竖屏，不支持独立编辑锁屏主题。但美学构图可在横屏和竖屏生成的时钟的差异信息，并分开存放。
   * 为保证数据一致性，在锁屏编辑器编辑时，需同步写入关联的限定符路径中。此处返回关联的限定符。
   * @param qualifier 主题路劲限定符
   * @returns 关联的主题路劲限定符
   */
  getEditTogetherQualifier(qualifier: string): string {
    let editTogetherQualifier = qualifier;
    switch (qualifier) {
      case ThemeScene.UNFOLDED:
        editTogetherQualifier = ThemeScene.LAND_UNFOLDED;
        break;
      case ThemeScene.LAND_UNFOLDED:
        editTogetherQualifier = ThemeScene.UNFOLDED;
        break;
      case ThemeScene.UNFOLDED2:
        editTogetherQualifier = ThemeScene.LAND_UNFOLDED2;
        break;
      case ThemeScene.LAND_UNFOLDED2:
        editTogetherQualifier = ThemeScene.UNFOLDED2;
        break;
      case ThemeScene.LAND:
        if (DeviceHelper.isPadOr2in1PcType()) {
          editTogetherQualifier = ThemeScene.BASE;
        }
        break;
      case ThemeScene.BASE:
        if (DeviceHelper.isPadOr2in1PcType()) {
          editTogetherQualifier = ThemeScene.LAND;
        }
        break;
    }
    return editTogetherQualifier;
  }

  /**
   * 用当前场景的缓存信息刷新锁屏UI主题
   * @param newScene 当前场景
   * @param oldScene 之前的旧场景
   * @returns true表示主题发生变化，否则false
   */
  protected applyThemeByCache(newScene: ThemeScene, oldScene: ThemeScene): boolean {
    let needRefreshUI: boolean = false;
    let isInEditor: boolean = ScreenLockStateManager.getInstance().isInEdite;
    log.showInfo(`applyThemeByCache isInEditor:${isInEditor}`);
    this.uiThemeInfos?.forEach((uiThemeInfo) => {
      if (isInEditor) {
        let cacheEditorThemeInfo = this.themeInfosInEditor?.get(newScene) as LockscreenThemeConfig;
        this.updateEditorCacheThemeInfo(this.getFormConfig(), oldScene);
        if (!cacheEditorThemeInfo) {
          log.warn(`applyThemeByCache not found cacheEditorThemeInfo for ${newScene}`);
          return;
        }
        needRefreshUI = true;
        this.applyClockStyleByCache(uiThemeInfo, cacheEditorThemeInfo.clock, isInEditor);
      } else {
        let cacheThemeInfo = this.getCurSceneThemeInfo(newScene) as LockscreenThemeConfig;
        if (!cacheThemeInfo) {
          log.warn(`applyThemeByCache not found cacheThemeInfo for ${newScene}`);
          return;
        }
        let oldThemeInfo = this.getCurSceneThemeInfo(oldScene) as LockscreenThemeConfig;
        // 若两个场景的主题信息无差异，则不刷新UI。如横屏和竖屏，在没有美学构图生成的差异信息时，无需刷新UI
        let noThemeChange = CommonUtil.isAllPropertyEquals(oldThemeInfo.clock, cacheThemeInfo.clock);
        if (noThemeChange) {
          log.warn(`applyThemeByCache no theme change between ${newScene} and ${oldScene}`);
          return;
        }
        if (!this.isDefaultTheme) {
          // 非默认主题，刷新全部主题属性
          needRefreshUI = true;
          this.applyClockStyleByCache(uiThemeInfo, cacheThemeInfo.clock);
        } else {
          // 默认主题，只有坐标不同
          let curClockStyle = uiThemeInfo as AnyClock;
          curClockStyle.x = cacheThemeInfo.clock.positionX;
          curClockStyle.y = cacheThemeInfo.clock.positionY;
          if (DeviceHelper.isThreeFoldProduct()) {
            needRefreshUI = true;
            curClockStyle.layout = cacheThemeInfo?.clock?.layout;
            curClockStyle.clockFontFamily = cacheThemeInfo?.clock?.fontFamily;
          }
          log.showInfo(`applyThemeByCache change default theme x:${curClockStyle.x}, y:${curClockStyle.y}`)
        }
      }
    });
    if (needRefreshUI) {
      this.notifyThemeChanged();
    }
    return needRefreshUI;
  }

  protected applyClockStyleByCache(uiThemeInfo: ThemeInfo, cacheClockParams: ThemeInfo, fromCache: boolean = false) {
    let curClockStyle = uiThemeInfo as AnyClock;
    if (!curClockStyle) {
      log.showWarn(`applyClockStyleByCache curClockStyle is undefined`);
      return;
    }
    let cacheStyle = cacheClockParams as IThemeParam;
    if (!cacheStyle) {
      log.showWarn(`applyClockStyleByCache cacheStyle is undefined`);
      return;
    }
    log.showInfo(`applyClockStyleByCache newScene:${this.scene}, update layout to ${cacheStyle.layout}, ` +
      `x:${cacheStyle.positionX}, y:${cacheStyle.positionY}`);
    curClockStyle.x = cacheStyle.positionX;
    curClockStyle.y = cacheStyle.positionY;
    curClockStyle.layout = cacheStyle.layout;
    curClockStyle.alignment = cacheStyle.textAlign;
    curClockStyle.clockStrokeColor = cacheStyle.color;
    curClockStyle.clockFontFamily = cacheStyle.fontFamily;
    curClockStyle.isClockTextShadowEnabled = cacheStyle.textShadow;
    curClockStyle.isClockTextBlurEffectEnabled = cacheStyle.textBlurEffect;
    curClockStyle.isClockDateVisible = cacheStyle.dateVisible;
    curClockStyle.isClockLunarVisible = cacheStyle.lunarVisible;
    curClockStyle.isClockSignatureVisible = cacheStyle?.signatureVisible;
    curClockStyle.clockSignatureText = cacheStyle.signatureText;
    curClockStyle.aestheticColorArgs = cacheStyle.aestheticColorArgs;
    curClockStyle.clockDegreeNumber = cacheStyle.clockDegree;
    GlobalStatusCache.getInstance().setStatus('clockFontFamily', curClockStyle.clockFontFamily);
    this.runAfterScreenOnEnd = () => {
      ScreenLockThemeManager.getInstance().notifyUpdateCardStyle(JSON.stringify({
        fontFamily: cacheStyle.fontFamily,
        mainTextWeight: ClockStaticData.getTimeFontWeightStr(cacheStyle.fontFamily)
      }));
      log.showInfo(`notifySendClockStyleToDesktop finish`);
    }
    if (this.isScreenOnEnd) {
      this.runAfterScreenOnEnd();
      this.runAfterScreenOnEnd = null;
    }
  }

  public getDefaultThemeParams(qualifier: string): LockscreenThemeConfig {
    return ScreenLockThemeManager.getInstance().getDefaultThemeParams(qualifier);
  }

  private setGStateDefaultThemeParam(qualifier: string, sourceParam: LockscreenThemeConfig): void {
    ScreenLockThemeManager.getInstance().setGStateDefaultThemeParam(qualifier, sourceParam);
  }

  /**
   * 查询当前时钟样式
   */
  public getCurClockStyle(): AnyClock | undefined {
    return this.uiThemeInfos?.get(DataType.CLOCK_STYLE) as AnyClock;
  }

  /**
   * 获取当前场景的主题信息
   * @returns 当前场景的主题信息
   */
  public getCurSceneThemeInfo(newScene?: string): ThemeInfo {
    if (!newScene) {
      newScene = this.getCurrentThemeQualifier();
    }
    return this.themeInfos?.get(newScene);
  }

  /**
   * 按限定符优先级获取主题。
   * 如：当需要unfolded-land主题时，若不存在，则取unfolded的主题信息；
   * 若unfolded的主题信息不存在，则取base；
   * 若base的主题信息不存在用default默认值
   *
   * @param qualifier 要获取的主题限定符
   * @param themeParams 异壁纸主题信息集合
   * @returns 限定符qualifier应该匹配的主题信息
   */
  public getThemeParamsByPriority(qualifier: string,
    themeParams: Map<Qualifier, LockscreenThemeConfig>): LockscreenThemeConfig {
    let defaultPriorityThemeParams = this.getDefaultThemeParams(qualifier);
    if (themeParams.has(qualifier)) {
      let matchedThemeParams = ObjectCopyUtil.deepClone(themeParams.get(qualifier))
      if (matchedThemeParams) {
        return matchedThemeParams;
      }
    }
    log.showWarn(`themeParams of ${qualifier} is null`);
    // 当前qualifier无直接对应主题，根据对应同步编辑主题样式处理（需同步刷新补偿坐标位置）
    let editTogetherQualifier = this.getEditTogetherQualifier(qualifier);
    if (qualifier !== editTogetherQualifier && themeParams.has(editTogetherQualifier)) {
      let matchedThemeParams = ObjectCopyUtil.deepClone(themeParams.get(editTogetherQualifier))
      if (matchedThemeParams) {
        matchedThemeParams.clock.positionX = defaultThemeParam.clock.positionX;
        matchedThemeParams.clock.positionY = defaultThemeParam.clock.positionY;
        return matchedThemeParams;
      }
    }
    log.showWarn(`themeParams of ${editTogetherQualifier} is null thus cannot be used on ${qualifier}`);
    // 当前qualifier不存在对应可用的主题信息，样式按默认处理
    return defaultPriorityThemeParams;
  }

  /**
   * 亮屏结束处理，因桌面天气时钟的切换依赖锁屏的通知。若手机完全息屏，再进行内外屏切换，此时天气进程被功耗管控
   * 无法通知到天气完成样式切换。因此考虑将完全息屏期间锁屏时钟样式切换的事件，在亮屏结束时进行通知
   * @param isScreenOnEnd 是否亮屏结束
   */
  public onScreenOnEndChange(isScreenOnEnd: boolean) {
    if (!this.isMultiSceneThemeProduct) {
      return;
    }
    if (this.isScreenOnEnd === isScreenOnEnd) {
      return;
    }
    this.isScreenOnEnd = isScreenOnEnd;
    let pendingRun = !CommonUtils.isInvalid(this.runAfterScreenOnEnd);
    log.showInfo(`onScreenOnEndChange isScreenOnEnd:${isScreenOnEnd}, pendingRun:${pendingRun}`);
    if (this.isScreenOnEnd && pendingRun) {
      this.runAfterScreenOnEnd?.();
      this.runAfterScreenOnEnd = null;
    }
  }

  /**
   * 是否支持多场景主题编辑，如折叠屏
   * @returns true 支持多场景主题编辑，否则false
   */
  public isSupportMultiSceneTheme(): boolean {
    return this.isMultiSceneThemeProduct;
  }

  /**
   * 获取当前缓存的主题配置
   *
   * @param qualifier 场景识别字段
   * @returns 主题配置
   */
  public getTargetSceneThemeEditCfg(qualifier: Qualifier): LockscreenThemeConfig | undefined {
    let themeInfo: LockscreenThemeConfig | undefined = undefined;
    this.themeInfosInEditor?.forEach((editorThemeInfo, themeScene) => {
      if (themeScene === qualifier) {
        themeInfo = editorThemeInfo as LockscreenThemeConfig;
      }
    })
    return themeInfo;
  }

  /**
   * 获取需要写入的主题包信息
   * @param curSlConfig 当前用户编辑的主题信息
   * @returns 包含当前用户编辑的主题信息，以及其他伴随写入的主题包信息
   */
  public getMultiSceneThemeEditCfg(): Map<string, LockscreenConfig | undefined> {
    let slConfigsToSave: Map<string, LockscreenConfig | undefined> = new Map();
    this.themeInfosInEditor?.forEach((editorThemeInfo, themeScene) => {
      let editorThemeConfig = editorThemeInfo as LockscreenThemeConfig;
      log.showInfo(`getMultiSceneThemeEditCfg themeScene:${themeScene}, layout:${editorThemeConfig.clock.layout}, ` +
        `x:${editorThemeConfig.clock.positionX}, y:${editorThemeConfig.clock.positionY}`);
      let editorCfgArg = this.transformConfig(editorThemeConfig);
      // 卡片将时钟顶上去场景，艺术签名时钟样式不显示卡片，不涉及
      let clockLayout = editorCfgArg?.clock?.layout;
      let curClockObj = (this.uiThemeInfos?.get(DataType.CLOCK_STYLE) as AnyClock);
      let clockGridHeight = curClockObj?.getGridAmountHeight(clockLayout) ?? 0;
      let formHeight = this.getFormHeight(editorCfgArg);
      let clockDistance = (editorThemeConfig?.clock?.positionY ?? 0) +
        clockGridHeight + formHeight - this.getMaxAmount(themeScene);
      if (clockDistance > 0) {
        editorCfgArg.clock.positionY -= clockDistance;
      }
      log.showInfo(`getMultiSceneThemeEditCfg ${clockDistance}, ${themeScene}, ${editorCfgArg?.clock?.positionY}`);

      slConfigsToSave.set(themeScene, editorCfgArg);
    })
    return slConfigsToSave;
  }

  private getMaxAmount(themeScene: string) {
    if (DeviceHelper.isPadOr2in1PcType()) {
      if (themeScene === ThemeScene.BASE) {
        return PAD_GRID_AMOUNT_Y;
      }
      return PAD_GRID_AMOUNT_LAND_Y;
    }
    if (themeScene === ThemeScene.UNFOLDED2) {
      return PAD_GRID_AMOUNT_Y;
    }
    if (themeScene === ThemeScene.LAND_UNFOLDED2) {
      return PAD_GRID_AMOUNT_LAND_Y;
    }
    return COMMON_GRID_AMOUNT_Y;
  }

  private getFormHeight(config:LockscreenConfig): number {
    let positionYSet: HashSet<number> = new HashSet();
    config?.form?.list?.forEach(form => {
      positionYSet.add(form.positionY);
    })
    return positionYSet.length;
  }

  protected transformConfig(themeCfg: LockscreenThemeConfig): LockscreenConfig {
    let newClockConfig: ClockInnerConfig = new ClockInnerConfig();
    newClockConfig.positionX = themeCfg.clock.positionX;
    newClockConfig.positionY = themeCfg.clock.positionY;
    newClockConfig.layout = themeCfg.clock.layout;
    newClockConfig.textAlign = themeCfg.clock.textAlign;
    newClockConfig.textShadow = themeCfg.clock.textShadow;
    newClockConfig.textBlurEffect = themeCfg.clock.textBlurEffect;
    newClockConfig.editStatus = false;
    newClockConfig.color = themeCfg.clock.color;
    newClockConfig.fontFamily = themeCfg.clock.fontFamily;
    newClockConfig.signatureVisible = themeCfg.clock.signatureVisible;
    newClockConfig.signatureText = themeCfg.clock.signatureText;
    newClockConfig.isShowAsCompound = themeCfg.clock.isShowAsCompound;
    newClockConfig.layoutDetail = themeCfg.clock.layoutDetail;
    newClockConfig.aestheticColorArgs = themeCfg.clock.aestheticColorArgs;
    newClockConfig.isLightWallpaper = themeCfg.clock.isLightWallpaper;
    newClockConfig.clockDegree = themeCfg.clock.clockDegree;
    newClockConfig.version = CONFIG_VERSION;
    let lockscreenConfig: LockscreenConfig = new LockscreenConfig();
    lockscreenConfig.clock = newClockConfig;
    lockscreenConfig.form = themeCfg.form;
    return lockscreenConfig;
  }

  notifyThemeChanged() {
    this.themeChangeListener?.forEach(listener => {
      listener.onThemeChanged();
    })
  }

  registerMultiSceneThemeChangeListener(listener: MultiSceneThemeChangeListener) {
    if (!this.themeChangeListener?.has(listener)) {
      this.themeChangeListener?.add(listener);
    }
  }

  unregisterMultiSceneThemeChangeListener(listener: MultiSceneThemeChangeListener) {
    if (this.themeChangeListener?.has(listener)) {
      this.themeChangeListener?.remove(listener);
    }
  }
}

let sMultiSceneThemeManager: MultiSceneThemeManager = SingletonHelper.getInstance(MultiSceneThemeManager, TAG);

export default sMultiSceneThemeManager as MultiSceneThemeManager;