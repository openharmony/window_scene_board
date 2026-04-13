/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import type Want from '@ohos.app.ability.Want';
import { CallToState } from '@ohos/commonconstants';
import { SCBSceneOrientation } from './SCBSceneOrientation';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { StartMode } from '../common/SCBSceneEnums';
import { SCBSceneSessionManager } from './SCBSceneSessionManager';
import { WinLog, WinLogDomain } from '../../utils/WinLog';

export enum SCBSceneMode {
  UNDEFINED = 0,
  FULLSCREEN = 1,
  PRIMARY = 100,
  SECONDARY,
  FLOATING = 10000,
  PIP
}

const DEFAULT_SCENE_MODE = SCBSceneMode.FULLSCREEN;
const INVALID_SCREEN_ID = -1;
export const DEFAULT_REQUEST_ID = -1;

/**
 * Information of a scene.
 */
const TAG = 'SCBSceneSession';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export interface CallerInfo {
  persistentId: number;
  windowMode: SCBSceneMode;
}

export class SCBSceneInfo {
  /**
   * Bundle name.
   */
  bundleName: string;

  /**
   * Module name.
   */
  moduleName: string;

  /**
   * Ability name.
   */
  abilityName: string;

  /**
   * unclearableSession.
   */
  unclearableSession: boolean;

  /**
   * App index
   */
  appIndex: number = 0;

  /**
   * is session locked in recent by user
   */
  isLockedInRecent: boolean = false;

  /**
   * want
   */
  want: Want;

  /**
   * requestId
   */
  private requestId_: number = DEFAULT_REQUEST_ID;

  /**
   * Identifier which screen the scene is displayed. default is invalid screen
   */
  screenId: number = INVALID_SCREEN_ID;

  /**
   * The scene persistentId
   */
  persistentId: number = 0;

  /**
   * caller persistent id
   */
  callerPersistentId?: number = 0;

  /**
   * caller bundle name
   */
  callerBundleName?: string = '';

  /**
   * caller ability name
   */
  callerAbilityName?: string = '';

  /**
   * additional Callers
   */
  additionalCallers: Array<CallerInfo> = [];

  /**
   * to persistent id
   */
  toPersistentId: number = 0;

  /**
   * ability launchType
   */
  launchType: bundleManager.LaunchType = bundleManager.LaunchType.SINGLETON;

  /**
   * ability startMode
   */
  startMode: StartMode = StartMode.MAIN_TASK;

  /**
   * ability callState
   */
  callState: number = CallToState.UNKNOWN;

  /**
   * True start a new scene otherwise priority to start the exist scene.
   */
  isNewInstance: boolean = false;

  /**
   * force enter immersive fullScreen when new Create session
   */
  fullScreenStart: boolean = false;

  /**
   * RotationStrategy, default is undefined
   */
  rotationStrategy: SCBSceneOrientation = SCBSceneOrientation.UNSPECIFIED;

  /**
   * WindowMode from fwk, default is undefined
   */
  private _windowMode: SCBSceneMode = SCBSceneMode.UNDEFINED;

  /**
   * Indicates whether the window is a control window.
   */
  isAppUseControl?: boolean;

  /**
   * Indicates whether the window has privacy mode control.
   */
  hasPrivacyModeControl?: boolean;

  /**
   * Indicates whether the window is unclearable in recent tasks.
   */
  isUnclearableInRecent?: boolean;

  /**
   * Extends info from SceneBoard, not from native.
   * @description Notice! before or after get to use, you need to check has/null/undefined firstly.
   */
  extendsInfo: Map<string, boolean> = new Map();

  /**
   * Indicates whether this window is configured with AbilityHook.
   */
  isAbilityHook: boolean = false;

  /**
   * is need find form other screen
   */
  needFindOtherScreen: boolean = true;

  public updateWindowModeAndSync(windowMode: SCBSceneMode): void {
    if (this._windowMode !== windowMode) {
      this._windowMode = windowMode;
      sceneSessionManager.updateWindowMode(this.persistentId, windowMode);
      SCBSceneSessionManager.getInstance().notifyUpdateWindowMode(windowMode, this.persistentId);
      WinLog.showInfo(WinLogDomain.WMS_LAYOUT, `updateWindowMode sceneSession:${this.persistentId} windowMode: ${windowMode}`);
    } else {
      log.showWarn(`updateWindowMode current windowMode:${windowMode} same with new windowMode`);
    }
  }

  public get windowMode(): SCBSceneMode {
    return this._windowMode;
  }

  public set windowMode(mode:SCBSceneMode) {
     this._windowMode = mode;
  }

  /**
   * If the opertion for the session is clear
   */
  isClearSession: boolean = false;

  /**
   * is request from persistent recover
   */
  isPersistentRecover: boolean = false;

  /**
   * custom window top
   */
  windowTop: number;

  /**
   * custom window left
   */
  windowLeft: number;

  /**
   * custom window width
   */
  windowWidth: number;

  /**
   * custom window height
   */
  windowHeight: number;

  /**
   * custom max window width
   */
  maxWindowWidth: number;
 
   /**
   * custom min window width
   */
  minWindowWidth: number;
 
  /**
   * custom max window height
   */
  maxWindowHeight: number;
 
   /**
   * custom min window height
   */
  minWindowHeight: number;

  /**
   * custom window whether start with animations
   */
  withAnimation: boolean;

  /**
   * module.json5 configure window top
   */
  configWindowTop?: string;

  /**
   * module.json5 configure window left
   */
  configWindowLeft?: string;
  
  /**
   * module.json5 configure window width
   */
  configWindowWidth?: number;
  
  /**
   * module.json5 configure window height
   */
  configWindowHeight?: number;

  /**
   * module.json5 configure window height
   */
  isMaximize?: boolean; 

  /**
   * custom window whether focused while on show
   */
  focusedOnShow: boolean = true;

  /**
   * custom window whether on cast scene
   */
  isCastScene?: boolean = false;

  /**
   * custom param to control is openAbilityByLaunchType or not
   */
  isStartByLaunchTypeConfig: boolean = false;

  /**
   *  is the scene started by scene with the callerId
   */
  isCalledRightlyByCallerId: boolean = false;

  /**
   *  atomic service flag used in install-free scene
   */
  isAtomicService: boolean = false;

  /**
   *  whether in install-free mode
   */
  isStartupInstallFree: boolean = false;

  /**
   * whether to clear in notShowRecent
   */
  needClearInNotShowRecent: boolean = false;

  /**
   * whether is Hide scene
   */
  isHide: boolean = false;

  /**
   * whether create new instance
   */
  isNewAppInstance: boolean = false;

  /**
   * instance key for multi instance
   */
  appInstanceKey: string = '';

  /**
   * whether is start from icon
   */
  isFromIcon: boolean = false;

  /**
   * Indicates which window mode is supported
   */
  supportWindowModes: Array<bundleManager.SupportWindowMode>;

  expectWindowMode?: number;

  isStartFromAppDock?: boolean;

  dockAppDirection?: number;

  isAppFromRecentAppsOrDockApps?: number;

  // Is screenId not specified during the first startup
  isScreenIdNotSpecified: boolean = false;

  specifiedFlag?: string;

  label: string = '';


  // The animation configuration of start system scene animation
  startAnimationSystemOptions?: sceneSessionManager.StartAnimationSystemOptions;

  // The animation configuration of start scene animation
  startAnimationOptions?: sceneSessionManager.StartAnimationOptions;

  // The atomicServiceInfo of compatible mode
  atomicServiceInfo?: sceneSessionManager.AtomicServiceInfo;

  constructor(bundleName: string, moduleName: string, abilityName: string, appIndex: number = 0,
    persistentId: number = 0) {
    this.bundleName = bundleName;
    this.moduleName = moduleName;
    this.abilityName = abilityName;
    this.appIndex = appIndex;
    this.persistentId = persistentId;
    this._windowMode = DEFAULT_SCENE_MODE;
    this.rotationStrategy = SCBSceneOrientation.UNSPECIFIED;
  }

  public static clone(info: SCBSceneInfo):SCBSceneInfo {
    let result = new SCBSceneInfo(info.bundleName, info.moduleName, info.abilityName, info.appIndex, info.persistentId);
    result.screenId = info.screenId;
    result.callerPersistentId = info.callerPersistentId;
    result.callerBundleName = info.callerBundleName;
    result.callerAbilityName = info.callerAbilityName;
    result.toPersistentId = info.toPersistentId;
    result.launchType = info.launchType;
    result.startMode = info.startMode;
    result.callState = info.callState;
    result.isNewInstance = info.isNewInstance;
    result.fullScreenStart = info.fullScreenStart;
    result.rotationStrategy = info.rotationStrategy;
    result.isStartFromAppDock = info.isStartFromAppDock;
    result.dockAppDirection = info.dockAppDirection;
    result.isAppFromRecentAppsOrDockApps = info.isAppFromRecentAppsOrDockApps;
    result.expectWindowMode = info.expectWindowMode;
    result.supportWindowModes = info.supportWindowModes;
    result.isFromIcon = info.isFromIcon;
    result.want = info.want;
    return result;
  }

  /**
   * whether is equal to
   *
   * @param { SCBSceneInfo } info
   * @return { Boolean }
   */
  public equalTo(info: SCBSceneInfo): boolean {
    if (this.bundleName === info.bundleName &&
      (!this.moduleName || !info.moduleName || this.moduleName === info.moduleName) &&
      this.abilityName === info.abilityName &&
      this.appIndex === info.appIndex &&
      this.appInstanceKey === info.appInstanceKey) {
      return true;
    }
    return false;
  }

  public equal(abilityName:string,bundleName:string,moduleName?:string): boolean {
    if (this.bundleName === bundleName &&
      (!this.moduleName || !moduleName || this.moduleName === moduleName) &&
      this.abilityName === abilityName ) {
      return true;
    }
    return false;
  }

  public initWindowLimit(maxWindowWidth: number, minWindowWidth: number, maxWindowHeight: number, minWindowHeight: number): void {
    this.maxWindowWidth = maxWindowWidth;
    this.minWindowWidth = minWindowWidth;
    this.maxWindowHeight = maxWindowHeight;
    this.minWindowHeight = minWindowHeight;
  }

  public toJsonString(): string {
    return `{persistentId:${this.persistentId}, screenId: ${this.screenId}, bundleInfo:${this.getName()}, ` +
      `unclearableSession:${this.unclearableSession}, callerPersistentId:${this.callerPersistentId}, callerAbilityName: ` +
      `${this.callerAbilityName}, toPersistentId:${this.toPersistentId}, launchType:${this.launchType}, isNewInstance:${this.isNewInstance}, ` +
      `fullScreenStart:${this.fullScreenStart}, _windowMode:${this._windowMode}, isAppUseControl:${this.isAppUseControl}, ` +
      `isUnclearableInRecent:${this.isUnclearableInRecent}, focusedOnShow:${this.focusedOnShow}, isAtomicService:${this.isAtomicService}` +
      `isStartupInstallFree:${this.isStartupInstallFree}, isNewAppInstance:${this.isNewAppInstance}, ` +
      `appInstanceKey:${this.appInstanceKey}}, startMode:${this.startMode}`;
  }

  public isPhoneCall(): boolean {
    let phoneSceneList: sceneSessionManager.SceneInfo[] = [
      { bundleName: 'com.ohos.callui', moduleName: '', abilityName: 'com.ohos.callui.MainAbility', appIndex: 0 },
      { bundleName: 'com.ohos.meetimeservice', moduleName: '', abilityName: 'CallUIKitAbility', appIndex: 0 }
    ];

    for (let item of phoneSceneList) {
      if (this.bundleName === item.bundleName && this.abilityName === item.abilityName) {
        return true;
      }
    }

    return false;
  }

  public isSameAbility(info: SCBSceneInfo): boolean {
    if (!info) {
      return false;
    }
    return this.bundleName === info.bundleName &&
      this.moduleName === info.moduleName &&
      this.abilityName === info.abilityName;
  }

  public isSameAbilityAndAppIndex(info: SCBSceneInfo): boolean {
    if (!info) {
      return false;
    }
    return this.bundleName === info.bundleName &&
      this.moduleName === info.moduleName &&
      this.abilityName === info.abilityName &&
      this.appIndex === info.appIndex;
  }

  public isSameBundleWithMultiApp(info: SCBSceneInfo): boolean {
    if (!info) {
      return false;
    }
    return this.bundleName === info.bundleName &&
      this.appIndex === info.appIndex &&
      this.appInstanceKey === info.appInstanceKey;
  }

  public isSameBundle(info: SCBSceneInfo): boolean {
    if (!info) {
      return false;
    }
    return this.bundleName === info.bundleName;
  }

  public getName(): string {
    return `${this.abilityName}/${this.bundleName}/${this.moduleName}/${this.appIndex}`;
  }
   
  public getWindowLimitString(): string {
    return 'maxWindowWidth: ' + this.maxWindowWidth + ' minWindowWidth: ' + this.minWindowWidth +
      ' maxWindowHeight: ' + this.maxWindowHeight + ' minWindowHeight: ' + this.minWindowHeight;
  }

  public resetRequestId(): void {
    this.requestId_ = DEFAULT_REQUEST_ID;
  }

  public set requestId(requestId: number) {
    this.requestId_ = requestId;
  }

  public get requestId(): number {
    return this.requestId_;
  }
}
