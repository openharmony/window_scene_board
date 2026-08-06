/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { systemParameterEnhance } from '@kit.BasicServicesKit';
import { DeviceHelper, FoldPhoneTypeValue } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBScreenSession, SCBScreenSessionManager } from '../TsIndex';
import { RotationConstants } from '@ohos/commonconstants';

const TAG = 'SCBRotationConfig';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

const TRUE_STRING: string = '1';
const FALSE_STRING: string = '0';
const DEFAULT_ORIENTATION_MAPPING_STRING: string = '0,90,180,270';
const DEFAULT_ORIENTATION_MAPPING_G_STATE_STRING: string = '90,0,270,180';
const DEFAULT_FIX_ROTATION_STRING: string = '-1';
const DEFAULT_FIX_ROTATION: number = -1;
const CONFIG_INDEX_ZERO: number = 0;
const CONFIG_INDEX_ONE: number = 1;
const CONFIG_INDEX_TWO: number = 2;
const CONFIG_INDEX_THREE: number = 3;
const EMPTY_STRING = '';
const VALID_ORIENTATION_MAPPING_ARRAY = [0, 90, 180, 270];

export const DEVICE_FOLD_SCREEN_TYPE = 'const.window.foldscreen.type';

export const DEVICE_ROTATABLE = 'const.window.device.rotatable';

export const DEVICE_ORIENTATION_MAP = 'const.window.device.orientation_map';

export const DEVICE_COMPATIBLE_LANDSCAPE = 'const.window.device.compatible_landscape';

export const DEVICE_FIXED_ROTATION = 'const.window.device.fixed_rotation';

export const DEVICE_ROTATION_OPTIMIZATION_SWITCH = 'const.window.device.rotation_optimization_switch';

const DEVICE_BORDER_OPTIONS_FOR_SCREEN = 'const.window.device.boardoptions_screen';
const DEVICE_BORDER_OPTIONS_FOR_SCENEPANEL = 'const.window.device.boardoptions_scenepanel';
const DEVICE_BORDER_OPTIONS_FOR_SCENECONTAINER = 'const.window.device.boardoptions_scenecontainer';

/**
 * 窗口显示角度映射
 */
export class OrientationMapping {
  _portrait: number = RotationConstants.ROTATION_0; // 竖屏
  _landscape: number = RotationConstants.ROTATION_90; // 横屏
  _reversePortrait: number = RotationConstants.ROTATION_180; // 反向竖屏
  _reverseLandscape: number = RotationConstants.ROTATION_270; // 反向横屏
}

/**
 * 旋转产品配置类型
 */
export enum RotationConfigType {
  // 非法的配置
  INVALID_CONFIG = -1,

  // 是否支持跟随sensor旋转
  ROTATABLE = 0,

  // 屏幕竖屏、横屏、反向竖屏、反向横屏对应的角度
  ORIENTATION_MAPPING = 1,

  // 是否使用SDK版本12之前的窗口方向定义
  COMPATIBLE_LANDSCAPE = 2,

  // 不受旋转策略影响的固定方向
  FIXED_ROTATION = 3
}

export enum OrientationExecutionResult {
  ORIENTATION_APPLIED = 0,
  ORIENTATION_IGNORED = 1,
  ORIENTATION_PENDING = 2,
  ORIENTATION_INVALID = 3
}

/**
 * SCBRotationConfig
 */
export class SCBRotationConfig {
  // 屏幕形态
  private foldScreenType: FoldPhoneTypeValue = FoldPhoneTypeValue.INVALID_VALUE;

  private rotatableArray: string[];

  private orientationMappingArray: string[];

  private compatibleLandscapeArray: string[];

  private fixedRotationArray: string[];

  // 旋转模块重构开关标记位
  private rotationOptimizationSwitch: boolean;

  private borderOptionsForScreen: string = '0px';
  private borderOptionsForScenePanel: string = '0px';
  private borderOptionsForSceneContainer: string = '0px';

  /**
   * Get the singleton of the rotation config.
   */
  static getInstance(): SCBRotationConfig {
    if (!globalThis.SCBRotationConfigInstance) {
      globalThis.SCBRotationConfigInstance = new SCBRotationConfig();
    }
    return globalThis.SCBRotationConfigInstance;
  }

  private constructor() {
    this.initDeviceRotationConfig();
  }

  /**
   *
   * loadDeviceFoldScreenTypeConfig
   *
   * getFoldScreenTypeConfig
   *
   * @returns {FoldPhoneTypeValue} FoldPhoneTypeValue 屏幕形态
   */
  private loadDeviceFoldScreenTypeConfig(): FoldPhoneTypeValue {
    try {
      // 默认形态 -- 直板机：-1, 屏幕数量：1
      let foldScreenType: string =
        systemParameterEnhance.getSync(DEVICE_FOLD_SCREEN_TYPE, EMPTY_STRING);
      log.showInfo('device fold Screen Type config string is : ' + foldScreenType);
      if (foldScreenType !== EMPTY_STRING) {
        const foldScreenTypeArray: string[] = foldScreenType.split(',');
        return Number.parseInt(foldScreenTypeArray[CONFIG_INDEX_ZERO]);
      }
    } catch (e) {
      log.showError('Get device fold Screen type config failed: %{public}s', e);
    }
    return FoldPhoneTypeValue.INVALID_VALUE;
  }

  /**
   *
   * isFoldAndExpandScreenType
   *
   * @param {FoldPhoneTypeValue} foldScreenType 屏幕形态
   *
   * @returns {boolean} isFoldAndExpandScreenType 屏幕形态是否是折叠态和展开态
   */
  private isFoldAndExpandScreenType(foldScreenType: FoldPhoneTypeValue): boolean {
    if (foldScreenType === FoldPhoneTypeValue.STRAIGHT || foldScreenType === FoldPhoneTypeValue.LARGE_FOLD ||
      foldScreenType === FoldPhoneTypeValue.EXTERNAL_FOLD ||
      foldScreenType === FoldPhoneTypeValue.EXPANDING_SUPER_FOLD) {
      return true;
    }
    return false;
  }

  /**
   *
   * isFoldExpandTentHoverScreenType
   *
   * @param {FoldPhoneTypeValue} foldScreenType 屏幕形态
   *
   * @returns {boolean} isFoldAndExpandScreenType 屏幕形态是否是折叠态、展开态、帐篷态和悬停态
   */
  private isFoldExpandTentHoverScreenType(foldScreenType: FoldPhoneTypeValue): boolean {
    return foldScreenType === FoldPhoneTypeValue.EXPANDING_NEX_FORMS;
  }

  /**
   *
   * isFMGScreenType
   *
   * @param {FoldPhoneTypeValue} foldScreenType 屏幕形态
   *
   * @returns {boolean} isFoldAndExpandScreenType 屏幕形态是否是F态M态G态
   */
  private isFMGScreenType(foldScreenType: FoldPhoneTypeValue): boolean {
    return foldScreenType === FoldPhoneTypeValue.EXPANDING_THREE_FOLD_PRODUCT;
  }

  /**
   *
   * getStringValueByFoldScreenType
   *
   * @param {string[]} configArray 旋转配置项字符串数组
   * @param {SCBScreenSession} screenSession 屏幕session
   * @param {RotationConfigType} rotationConfigType 旋转配置项类型
   *
   * @returns {string} configValue 配置项的值
   */
  private getStringValueByFoldScreenType(configArray: string[], screenSession: SCBScreenSession,
    rotationConfigType: RotationConfigType): string {
    let configIndex = this.getConfigValueIndex(screenSession);
    if (configArray.length > configIndex) {
      return configArray[configIndex];
    }
    // 如果对应的index上没有配置值，则根据对应的设备类型返回默认值
    return this.getDefaultRotationConfig(rotationConfigType);
  }

  /**
   *
   * getConfigValueIndex
   *
   * @param {SCBScreenSession} screenSession 屏幕session
   *
   * @returns {number} arrayIndex 配置项在数组中的index
   */
  private getConfigValueIndex(screenSession: SCBScreenSession): number {
    // 悬停态
    if (screenSession?.isTentHoverStatus) {
      return CONFIG_INDEX_THREE;
    }

    // 帐篷态 或 G态
    if (screenSession?.isTentStatus || SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
      return CONFIG_INDEX_TWO;
    }

    // M态 或 展开态
    if ((DeviceHelper.isThreeFoldProduct() && DeviceHelper.isMState()) ||
        screenSession?.isExpandStatus) {
      return CONFIG_INDEX_ONE;
    }

    // F态 或 折叠态 或 直板机
    return CONFIG_INDEX_ZERO;
  }

  /**
   *
   * getDefaultRotationConfig
   *
   * @param {RotationConfigType} rotationConfigType 旋转配置项类型
   *
   * @returns {string} defaultConfig 配置的默认值
   */
  private getDefaultRotationConfig(rotationConfigType: RotationConfigType): string {
    log.showInfo('getDefaultRotationConfig, rotationConfigType = ' + rotationConfigType);
    if (rotationConfigType === RotationConfigType.ROTATABLE) {
      if (DeviceHelper.isPhone() || DeviceHelper.DEVICE_TYPE === DeviceHelper.TYPE_TABLET) {
        return TRUE_STRING;
      }
      return FALSE_STRING;
    }

    if (rotationConfigType === RotationConfigType.ORIENTATION_MAPPING) {
      if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
        return DEFAULT_ORIENTATION_MAPPING_G_STATE_STRING;
      }
      return DEFAULT_ORIENTATION_MAPPING_STRING;
    }

    if (rotationConfigType === RotationConfigType.COMPATIBLE_LANDSCAPE) {
      if (DeviceHelper.isPhone()) {
        return TRUE_STRING;
      }
      return FALSE_STRING;
    }

    if (rotationConfigType === RotationConfigType.FIXED_ROTATION) {
      return DEFAULT_FIX_ROTATION_STRING;
    }
    log.showError('getDefaultRotationConfig failed! RotationConfigType is invalid');
    return FALSE_STRING;
  }

  /**
   *
   * getDeviceRotatableConfig
   *
   * @returns {string[]} rotatableConfig 是否支持跟随sensor旋转配置字符数组
   */
  private loadDeviceRotatableConfig(): string[] {
    try {
      let rotatableString: string = systemParameterEnhance.getSync(DEVICE_ROTATABLE, EMPTY_STRING);
      log.showInfo('device rotatable config string is : ' + rotatableString);
      if (rotatableString !== EMPTY_STRING) {
        return rotatableString.split(';');
      }
    } catch (e) {
      log.showError('Get device rotatable config failed: %{public}s', e);
    }
    const isDevicePhoneOrTablet = DeviceHelper.isPhone() || DeviceHelper.DEVICE_TYPE === DeviceHelper.TYPE_TABLET;
    const defaultConfig = isDevicePhoneOrTablet ? TRUE_STRING : FALSE_STRING;
    if (this.isFoldExpandTentHoverScreenType(this.foldScreenType)) {
      return [defaultConfig, defaultConfig, defaultConfig, defaultConfig];
    }
    if (this.isFMGScreenType(this.foldScreenType)) {
      return [defaultConfig, defaultConfig, defaultConfig];
    }
    if (this.isFoldAndExpandScreenType(this.foldScreenType)) {
      return [defaultConfig, defaultConfig];
    }
    return [defaultConfig];
  }

  /**
   *
   * getDeviceOrientationMapping
   *
   * @returns {string[]} orientationMapping 旋转orientation与屏幕角度的映射字符数组
   */
  private loadDeviceOrientationMappingConfig(): string[] {
    try {
      let orientationMappingsString: string =
        systemParameterEnhance.getSync(DEVICE_ORIENTATION_MAP, EMPTY_STRING);
      log.showInfo('device orientation mapping config string is : ' + orientationMappingsString);
      if (orientationMappingsString !== EMPTY_STRING) {
        return orientationMappingsString.split(';');
      }
    } catch (e) {
      log.showError('Get device orientation mapping config failed: %{public}s', e);
    }
    if (this.isFoldExpandTentHoverScreenType(this.foldScreenType)) {
      return [DEFAULT_ORIENTATION_MAPPING_STRING, DEFAULT_ORIENTATION_MAPPING_STRING,
        DEFAULT_ORIENTATION_MAPPING_STRING,
        DEFAULT_ORIENTATION_MAPPING_STRING];
    }
    if (this.isFMGScreenType(this.foldScreenType)) {
      return [DEFAULT_ORIENTATION_MAPPING_STRING, DEFAULT_ORIENTATION_MAPPING_STRING,
        DEFAULT_ORIENTATION_MAPPING_G_STATE_STRING];
    }
    if (this.isFoldAndExpandScreenType(this.foldScreenType)) {
      return [DEFAULT_ORIENTATION_MAPPING_STRING, DEFAULT_ORIENTATION_MAPPING_STRING];
    }
    return [DEFAULT_ORIENTATION_MAPPING_STRING];
  }

  /**
   *
   * parseOrientationMappingToObject
   *
   * @param {string} orientationMapping 旋转orientation与屏幕角度的映射
   *
   * @returns {OrientationMapping} orientationMappingObject 旋转orientation与屏幕角度的映射Object
   */
  private parseOrientationMappingToObject(orientationMapping: string): OrientationMapping {
    let orientationMappingObject: OrientationMapping = new OrientationMapping();
    const orientationMappingArray = orientationMapping.split(',');

    if (this.isValidOrientation(Number.parseInt(orientationMappingArray[CONFIG_INDEX_ZERO]))) {
      orientationMappingObject._portrait = Number.parseInt(orientationMappingArray[CONFIG_INDEX_ZERO]);
    } else {
      log.showError('parseRotationMappingToObject failed! invalid orientation in index 0!');
      if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
        orientationMappingObject._portrait = RotationConstants.ROTATION_90;
      }
    }

    if (orientationMappingArray.length > CONFIG_INDEX_ONE &&
    this.isValidOrientation(Number.parseInt(orientationMappingArray[CONFIG_INDEX_ONE]))) {
      orientationMappingObject._landscape = Number.parseInt(orientationMappingArray[CONFIG_INDEX_ONE]);
    } else {
      log.showError('parseRotationMappingToObject failed! invalid orientation in index 1!');
      if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
        orientationMappingObject._landscape = RotationConstants.ROTATION_0;
      }
    }

    if (orientationMappingArray.length > CONFIG_INDEX_TWO &&
    this.isValidOrientation(Number.parseInt(orientationMappingArray[CONFIG_INDEX_TWO]))) {
      orientationMappingObject._reversePortrait = Number.parseInt(orientationMappingArray[CONFIG_INDEX_TWO]);
    } else {
      log.showError('parseRotationMappingToObject failed! invalid orientation in index 2!');
      if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
        orientationMappingObject._reversePortrait = RotationConstants.ROTATION_270;
      }
    }

    if (orientationMappingArray.length > CONFIG_INDEX_THREE &&
    this.isValidOrientation(Number.parseInt(orientationMappingArray[CONFIG_INDEX_THREE]))) {
      orientationMappingObject._reverseLandscape = Number.parseInt(orientationMappingArray[CONFIG_INDEX_THREE]);
    } else {
      log.showError('parseRotationMappingToObject failed! invalid orientation in index 3!');
      if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
        orientationMappingObject._reverseLandscape = RotationConstants.ROTATION_180;
      }
    }
    return orientationMappingObject;
  }

  /**
   *
   * isValidOrientation
   *
   * @param {number} orientation orientation
   *
   * @returns {boolean} isValidOrientation 是否是合法的orientation
   */
  private isValidOrientation(orientation: number): boolean {
    return VALID_ORIENTATION_MAPPING_ARRAY.includes(orientation);
  }

  /**
   *
   * getDeviceOrientationMapping
   *
   * @returns {string[]} compatibleLandscape 是否使用SDK版本12之前的窗口方向定义配置项字符数组
   */
  private loadDeviceCompatibleLandscapeConfig(): string[] {
    try {
      let compatibleLandscapeString: string =
        systemParameterEnhance.getSync(DEVICE_COMPATIBLE_LANDSCAPE, EMPTY_STRING);
      log.showInfo('device compatible landscape config string is : ' + compatibleLandscapeString);
      if (compatibleLandscapeString !== EMPTY_STRING) {
        return compatibleLandscapeString.split(';');
      }
    } catch (e) {
      log.showError('Get device compatible landscape config failed: %{public}s', e);
    }
    const defaultConfig = DeviceHelper.isPhone() ? TRUE_STRING : FALSE_STRING;
    if (this.isFoldExpandTentHoverScreenType(this.foldScreenType)) {
      return [defaultConfig, defaultConfig, defaultConfig, defaultConfig];
    }
    if (this.isFMGScreenType(this.foldScreenType)) {
      return [defaultConfig, defaultConfig, defaultConfig];
    }
    if (this.isFoldAndExpandScreenType(this.foldScreenType)) {
      return [defaultConfig, defaultConfig];
    }
    return [defaultConfig];
  }

  /**
   *
   * getDeviceFixedRotationConfig
   *
   * @returns {string[]} fixedRotation 不受旋转策略影响的固定方向配置项字符数组
   */
  private loadDeviceFixedRotationConfig(): string[] {
    try {
      let fixedRotationString: string =
        systemParameterEnhance.getSync(DEVICE_FIXED_ROTATION, EMPTY_STRING);
      log.showInfo('device fixed rotation config string is : ' + fixedRotationString);
      if (fixedRotationString !== EMPTY_STRING) {
        return fixedRotationString.split(';');
      }
    } catch (e) {
      log.showError('Get device fixed rotation config failed: %{public}s', e);
    }
    if (this.isFoldExpandTentHoverScreenType(this.foldScreenType)) {
      return [DEFAULT_FIX_ROTATION_STRING, DEFAULT_FIX_ROTATION_STRING, DEFAULT_FIX_ROTATION_STRING,
        DEFAULT_FIX_ROTATION_STRING];
    }
    if (this.isFMGScreenType(this.foldScreenType)) {
      return [DEFAULT_FIX_ROTATION_STRING, DEFAULT_FIX_ROTATION_STRING, DEFAULT_FIX_ROTATION_STRING];
    }
    if (this.isFoldAndExpandScreenType(this.foldScreenType)) {
      return [DEFAULT_FIX_ROTATION_STRING, DEFAULT_FIX_ROTATION_STRING];
    }
    return [DEFAULT_FIX_ROTATION_STRING];
  }

  /**
   *
   * getDeviceRotationOptimizationSwitchConfig
   *
   * @returns {boolean} rotationOptimizationSwitchConfig 是否开启旋转模块重构优化配置项,默认返回false
   */
  private loadDeviceRotationOptimizationSwitchConfig(): boolean {
    try {
      // 旋转重构开关 -- 0：关闭, 1：开启
      let rotationOptimizationSwitch: string =
        systemParameterEnhance.getSync(DEVICE_ROTATION_OPTIMIZATION_SWITCH, FALSE_STRING);
      log.showInfo('device fold rotation optimization switch string is : ' + rotationOptimizationSwitch);
      return TRUE_STRING === rotationOptimizationSwitch;
    } catch (e) {
      log.showError('Get device rotation optimization switch config failed: %{public}s', e);
    }
    return false;
  }

  private loadDeviceBorderOptions() : void {
    try {
      this.borderOptionsForScreen = systemParameterEnhance.getSync(DEVICE_BORDER_OPTIONS_FOR_SCREEN, '0px');
      this.borderOptionsForScenePanel = systemParameterEnhance.getSync(DEVICE_BORDER_OPTIONS_FOR_SCENEPANEL, '0px');
      this.borderOptionsForSceneContainer = 
        systemParameterEnhance.getSync(DEVICE_BORDER_OPTIONS_FOR_SCENECONTAINER, '0px');
    } catch (e) {
      log.showError('Get device border options failed: %{public}s', e);
    }
  }

  /**
   * init device rotation config.
   */
  public initDeviceRotationConfig(): void {
    this.foldScreenType = this.loadDeviceFoldScreenTypeConfig();
    this.rotatableArray = this.loadDeviceRotatableConfig();
    this.orientationMappingArray = this.loadDeviceOrientationMappingConfig();
    this.compatibleLandscapeArray = this.loadDeviceCompatibleLandscapeConfig();
    this.fixedRotationArray = this.loadDeviceFixedRotationConfig();
    this.rotationOptimizationSwitch = this.loadDeviceRotationOptimizationSwitchConfig();
    this.loadDeviceBorderOptions();
  }

  /**
   *
   * isDeviceRotatable
   *
   * @param {SCBScreenSession} screenSession 屏幕session
   *
   * @returns {boolean} isDeviceRotatable 是否支持跟随sensor旋转
   */
  public isDeviceRotatable(screenSession: SCBScreenSession): boolean {
    if (!this.rotatableArray) {
      log.showError('Rotatable config is null!');
      return false;
    }
    let isDeviceRotatable: boolean = TRUE_STRING === this.getStringValueByFoldScreenType(this.rotatableArray,
      screenSession, RotationConfigType.ROTATABLE);
    log.showDebug('device rotatable config value is : ' + isDeviceRotatable);
    return isDeviceRotatable;
  }

  /**
   *
   * getDeviceOrientationMappingObject
   *
   * @param {SCBScreenSession} 屏幕session
   *
   * @returns {OrientationMapping} 旋转orientation与屏幕角度的映射
   */
  public getDeviceOrientationMappingObject(screenSession: SCBScreenSession): OrientationMapping {
    let orientationMappingObject = new OrientationMapping();
    if (!this.orientationMappingArray) {
      log.showError('OrientationMapping config is null!');
      if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
        orientationMappingObject._portrait = RotationConstants.ROTATION_90;
        orientationMappingObject._landscape = RotationConstants.ROTATION_0;
        orientationMappingObject._reversePortrait = RotationConstants.ROTATION_270;
        orientationMappingObject._reverseLandscape = RotationConstants.ROTATION_180;
      }
      return orientationMappingObject;
    }
    let orientationMappingString = this.getStringValueByFoldScreenType(this.orientationMappingArray,
      screenSession, RotationConfigType.ORIENTATION_MAPPING);
    orientationMappingObject = this.parseOrientationMappingToObject(orientationMappingString);
    log.showDebug('device orientation mapping config portrait is : ' + orientationMappingObject._portrait +
      ' landscape is : ' + orientationMappingObject._landscape + ' reversePortrait is : ' +
    orientationMappingObject._reversePortrait + ' reverseLandscape is : ' + orientationMappingObject._reverseLandscape);
    return orientationMappingObject;
  }

  /**
   *
   * getVerticalRotation
   *
   * @param {SCBScreenSession} screenSession 屏幕session
   *
   * @returns {number} VerticalRotation 竖屏对应的屏幕角度
   */
  public getVerticalRotation(screenSession: SCBScreenSession): number {
    let orientationMapping: OrientationMapping = this.getDeviceOrientationMappingObject(screenSession);
    log.showDebug('getVerticalRotation : ' + orientationMapping._portrait);
    return orientationMapping._portrait;
  }

  /**
   *
   * getHorizontalRotation
   *
   * @param {SCBScreenSession} screenSession 屏幕session
   *
   * @returns {number} horizontalRotation 横屏对应的屏幕角度
   */
  public getHorizontalRotation(screenSession: SCBScreenSession): number {
    let orientationMapping: OrientationMapping = this.getDeviceOrientationMappingObject(screenSession);
    let horizontalRotation = this.isDeviceCompatibleLandscape(screenSession) ?
    orientationMapping._reverseLandscape : orientationMapping._landscape;
    log.showDebug('getHorizontalRotation : ' + horizontalRotation);
    return horizontalRotation;
  }

  /**
   *
   * getReverseVerticalRotation
   *
   * @param {SCBScreenSession} screenSession 屏幕session
   *
   * @returns {number} ReverseVerticalRotation 反向竖屏对应的屏幕角度
   */
  public getReverseVerticalRotation(screenSession: SCBScreenSession): number {
    let orientationMapping: OrientationMapping = this.getDeviceOrientationMappingObject(screenSession);
    log.showDebug('getReverseVerticalRotation : ' + orientationMapping._reversePortrait);
    return orientationMapping._reversePortrait;
  }

  /**
   *
   * getReverseHorizontalRotation
   *
   * @param {SCBScreenSession} screenSession 屏幕session
   *
   * @returns {number} reverseHorizontalRotation 反向横屏对应的屏幕角度
   */
  public getReverseHorizontalRotation(screenSession: SCBScreenSession): number {
    let orientationMapping: OrientationMapping = this.getDeviceOrientationMappingObject(screenSession);
    let reverseHorizontalRotation = this.isDeviceCompatibleLandscape(screenSession) ?
    orientationMapping._landscape : orientationMapping._reverseLandscape;
    log.showDebug('getReverseHorizontalRotation : ' + reverseHorizontalRotation);
    return reverseHorizontalRotation;
  }

  /**
   *
   * isDeviceCompatibleLandscape
   *
   * @param {SCBScreenSession} screenSession 屏幕session
   *
   * @returns {boolean} isDeviceCompatibleLandscape 是否使用SDK版本12之前的窗口方向定义
   */
  public isDeviceCompatibleLandscape(screenSession: SCBScreenSession): boolean {
    if (!this.compatibleLandscapeArray) {
      log.showError('Compatible Landscape config is null!');
      return false;
    }
    let isDeviceCompatibleLandscape: boolean = TRUE_STRING ===
    this.getStringValueByFoldScreenType(this.compatibleLandscapeArray, screenSession,
      RotationConfigType.COMPATIBLE_LANDSCAPE);
    log.showDebug('device compatible landscape config value is : ' + isDeviceCompatibleLandscape);
    return isDeviceCompatibleLandscape;
  }

  /**
   *
   * getDeviceFixedRotation
   *
   * @param {SCBScreenSession} screenSession 屏幕session
   *
   * @returns {number} FixedRotation 不受旋转策略影响的固定方向
   */
  public getDeviceFixedRotation(screenSession: SCBScreenSession): number {
    if (!this.fixedRotationArray) {
      log.showError('Fixed Rotation config is null!');
      return DEFAULT_FIX_ROTATION;
    }
    let fixedRotation: number =
      Number.parseInt(this.getStringValueByFoldScreenType(this.fixedRotationArray, screenSession,
        RotationConfigType.FIXED_ROTATION));
    log.showDebug('device fixed rotation config value is : ' + fixedRotation);
    return fixedRotation;
  }

  /**
   *
   * isDeviceRotationOptimizationSwitchOn
   *
   * @returns {boolean} isDeviceRotationOptimizationSwitchOn 是否开启旋转重构优化
   */
  public isDeviceRotationOptimizationSwitchOn(): boolean {
    return this.rotationOptimizationSwitch;
  }

  public getDeviceBorderOptionsForScreen(): string {
    return this.borderOptionsForScreen;
  }

  public getDeviceBorderOptionsForScenePanel(): string {
    return this.borderOptionsForScenePanel;
  }

  public getDeviceBorderOptionsForSceneContainer(): string {
    return this.borderOptionsForSceneContainer;
  }
}
