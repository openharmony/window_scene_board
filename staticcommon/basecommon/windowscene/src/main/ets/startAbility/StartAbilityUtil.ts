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
import { AccountConstants, AccountMgr } from '@ohos/frameworkwrapper';
import { CommonUtils, Trace } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBConstants, PreLaunchType } from '@ohos/commonconstants';
import { ExtAppConstants } from '@ohos/commonconstants';
import { viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '../scene/session/SCBSceneSessionManager';
import { SCBSceneInfo, SCBSceneMode } from '../scene/session/SCBSceneInfo';
import hiSysEvent from '@ohos.hiSysEvent';
import type Want from '@ohos.app.ability.Want';
import camera from '@ohos.multimedia.camera';
import type featureAbility from '@ohos.ability.featureAbility';
import type { BusinessError } from '@ohos.base';
import type ctx from '@ohos.app.ability.common';
import { TaskpoolUtil } from '@ohos/basicutils';

const TAG = 'StartAbilityUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 应用启动相关工具类
 */
export class StartAbilityUtil {
  /**
   * 相机预加载是否需要优先执行
   */
  private static isPriority: boolean = false;


  static startLauncherAbilityWithModeByWant(want: Want, windowMode: SCBSceneMode, screenId?: number): void {
    screenId = screenId === undefined ? SCBSceneSessionManager.getInstance().mainScreenId : screenId;
    let paramBundleName = want.bundleName;
    let paramModuleName = want.moduleName;
    let paramAbilityName = want.abilityName;
    let sceneInfo = new SCBSceneInfo(paramBundleName, paramModuleName, paramAbilityName);
    sceneInfo.screenId = screenId;
    let queryKey = paramBundleName + paramModuleName + paramAbilityName;
    sceneInfo.launchType = SCBSceneSessionManager.getInstance().getAbilityLaunchType(queryKey);
    sceneInfo.want = want;

    const params = want?.parameters?.startParams as Map<string, Object>;
    sceneInfo.isStartByLaunchTypeConfig = params?.get(SCBConstants.IS_START_BY_LAUNCHTYPE_CONFIG) as boolean || false;
    sceneInfo.appIndex = params?.get(SCBConstants.START_APP_CLONE_INDEX) as number ?? 0;

    if (paramBundleName === SCBConstants.CAMERA_BUNDLE) {
      this.preLaunchCamera(PreLaunchType.TOUCH_UP);
    }
    log.info(`startApplication, launchType: ${sceneInfo.launchType}}, want.bundleName:%{public}s`, want.bundleName);
    sceneInfo.windowMode = windowMode;
    SCBSceneSessionManager.getInstance().startSceneFromIcon(sceneInfo);
    if (viewMgrPolicy.isViewShowing(ViewType.RECENT)) {
      viewMgrPolicy.hideView(ViewType.RECENT);
    }
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER) || viewMgrPolicy.isViewShowing(ViewType.APP_CENTER_EXT)) {
      if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
        let hideAppCenterWithAnimation = (GlobalContext.getInstance()
          .getObject('hideAppCenterWithAnimation')) as Function;
        hideAppCenterWithAnimation();
      }
    }

    const sysEventInfo = {
      domain: 'LAUNCHER_APP',
      name: 'START_ABILITY',
      eventType: hiSysEvent.EventType.BEHAVIOR,
      params: {
        'BUNDLE_NAME': paramBundleName,
        'ABILITY_NAME': paramAbilityName,
        'MODULE_NAME': paramModuleName
      }
    };
    try {
      hiSysEvent.write(sysEventInfo,
        (err, value) => {
          if (err) {
            log.showError(`startApplication hiSysEvent write error: ${err.code}`);
          } else {
            log.showDebug(`startApplication hiSysEvent write success: ${value}`);
          }
        });
    } catch (error) {
      log.error('startLauncherAbilityByWant write try error', error);
    }
  }

  /**
   * start the app by want
   *
   * @params want: want for start app
   */
  static startLauncherAbilityByWant(want: Want, screenId?: number): void {
    // 默认FullScreen
    StartAbilityUtil.startLauncherAbilityWithModeByWant(want, SCBSceneMode.FULLSCREEN, screenId);
  }

  /**
   * start the app
   *
   * @params paramAbilityName: Ability name
   * @params paramBundleName: Application package name
   */
  static startLauncherAbilityWithMode(windowMode: SCBSceneMode, paramAbilityName: string, paramBundleName: string,
    paramModuleName: string,
    startParams?: Map<string, Object>, screenId?: number, otherParams?: Map<string, Object>): void {
    let parameters: Record<string, Object> = { startParams: startParams };
    otherParams?.forEach((value, key) => {
      parameters[key] = value;
    });
    if (startParams?.has(SCBConstants.START_APP_CLONE_INDEX)) {
      parameters[SCBConstants.START_APP_CLONE_INDEX] = startParams.get(SCBConstants.START_APP_CLONE_INDEX);
    }
    if (startParams?.has(SCBConstants.OPEN_IN_NEW_WINDOW)) {
      parameters[SCBConstants.OPEN_IN_NEW_WINDOW] = startParams.get(SCBConstants.OPEN_IN_NEW_WINDOW);
    }
    if (startParams?.has(SCBConstants.CREATE_NEW_APP_INSTANCE_KEY)) {
      parameters[SCBConstants.CREATE_NEW_APP_INSTANCE_KEY] = startParams.get(SCBConstants.CREATE_NEW_APP_INSTANCE_KEY);
      log.showInfo(`startLauncherAbility ${paramBundleName} get CREATE_NEW_APP_INSTANCE_KEY`);
    }
    this.startLauncherAbilityWithModeByWant({
      bundleName: paramBundleName,
      abilityName: paramAbilityName,
      moduleName: paramModuleName,
      action: ExtAppConstants.ACTION_ANY_MAIN,
      entities: ['entity.system.home'],
      parameters: parameters,
    }, windowMode, screenId === undefined ? SCBSceneSessionManager.getInstance().mainScreenId : screenId);
  }

  /**
   * start the app
   *
   * @params paramAbilityName: Ability name
   * @params paramBundleName: Application package name
   */
  static startLauncherAbility(paramAbilityName: string, paramBundleName: string, paramModuleName: string,
    startParams?: Map<string, Object>, screenId?: number, otherParams?: Map<string, Object>): void {
    StartAbilityUtil.startLauncherAbilityWithMode(SCBSceneMode.FULLSCREEN, paramAbilityName, paramBundleName,
      paramModuleName, startParams, screenId, otherParams);
  }

  /**
   * start form config ability
   *
   * @params paramAbilityName
   * @params paramBundleName
   */
  static startAbilityFormEdit(paramAbilityName: string, paramBundleName: string, paramModuleName: string, paramCardId:
    string, isFromOuterMenu: boolean = false): void {
    log.showDebug(`startAbility abilityName: ${paramAbilityName},bundleName: ${paramBundleName}, moduleName: ${paramModuleName} ,paramCardId: ${paramCardId}`);
    (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).startAbility({
      bundleName: paramBundleName,
      abilityName: paramAbilityName,
      moduleName: paramModuleName,
      parameters:
      {
        formId: paramCardId,
        isFromOuterMenu: isFromOuterMenu,
      }
    }).then((ret) => {
      log.showDebug('startAbility');
    }, (err) => {
      log.error('startAbility catch error:', err);
    });
  }

  static startAbilityByName(paramAbilityName: string, paramBundleName: string, paramModuleName: string): void {
    log.showDebug(`startAbilityByName abilityName: ${paramAbilityName},bundleName: ${paramBundleName}, moduleName: ${paramModuleName}`);
    (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).startAbility({
      bundleName: paramBundleName,
      abilityName: paramAbilityName,
      moduleName: paramModuleName
    }).then(() => {
      log.showDebug('startAbilityByName');
    }, (err) => {
      log.error('startAbilityByName catch error:', err);
    });
  }

  /**
   * start application by uri
   *
   * @params paramBundleName application bundle name
   * @params abilityUri application ability uri
   */
  static async startLauncherAbilityByUri(paramBundleName: string, abilityUri: string): Promise<void> {
    log.showInfo(`startLauncherAbilityByUri bundleName:${paramBundleName} abilityUri:${abilityUri}`);
    return (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).startAbility({
      bundleName: paramBundleName,
      uri: abilityUri
    });
  }

  /**
   * start browser by uri
   *
   * @params uri
   */
  static async startBrowserByUri(paramUri: string): Promise<void> {
    log.showInfo(`startBrowserByUri paramUri:${paramUri}`);
    return (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).startAbility({
      action: 'ohos.want.action.viewData',
      entities: ['entity.system.browsable'],
      uri: paramUri
    }).then((ret) => {
      log.showDebug('startBrowserByUri');
    }, (err) => {
      log.error('startBrowserByUri catch error:', err);
    });
  }

  /**
   * 启动ability
   *
   * @param want 数据
   * @param callback
   */
  static startAbility(want: Want, callback?: (error?: BusinessError) => void): void {
    log.showDebug('startAbility, bundleName:%{public}s,moduleName:%{public}s,abilityName:%{public}s ', want?.bundleName,
      want?.moduleName, want?.abilityName);
    if (CommonUtils.isInvalid(want)) {
      log.showWarn('startAbility want is null');
      return;
    }
    this.startLauncherAbilityByWant(want);
    log.showInfo('startLauncherAbility');
    if (callback) {
      callback();
    }
  }

  static startAbilityFromOther(want: Want, isNewInstance?: boolean, callback?: (error?: BusinessError) => void): void {
    log.showDebug('startAbilityFromOther,bundleName:%{public}s,moduleName:%{public}s,abilityName:%{public}s',
      want?.bundleName, want?.moduleName, want?.abilityName);
    if (CommonUtils.isInvalid(want)) {
      log.showWarn('startAbilityFromOther want is null');
      return;
    }

    let paramBundleName = want.bundleName;
    let paramModuleName = want.moduleName;
    let paramAbilityName = want.abilityName;
    let sceneInfo = new SCBSceneInfo(paramBundleName, paramModuleName, paramAbilityName);
    let queryKey = paramBundleName + paramModuleName + paramAbilityName;
    if (want.parameters) {
      sceneInfo.appIndex = want.parameters[SCBConstants.START_APP_CLONE_INDEX] as number ?? 0;
      const screenId = want.parameters[SCBConstants.KEY_SCREEN_ID] as number;
      if (screenId) {
        sceneInfo.screenId = screenId;
      }
    }
    sceneInfo.launchType = SCBSceneSessionManager.getInstance().getAbilityLaunchType(queryKey);
    sceneInfo.want = want;
    if (isNewInstance) {
      sceneInfo.isNewInstance = isNewInstance;
    }
    log.showDebug(`startApplicationFromOther, launchType: ${sceneInfo.launchType}},bundleName:%{public}s,moduleName:%{public}s,abilityName:%{public}s `,
      want?.bundleName, want?.moduleName, want?.abilityName);
    SCBSceneSessionManager.getInstance().startSceneFromOther(sceneInfo);

    log.showInfo('startAbilityFromOther');
    if (callback) {
      callback();
    }
  }

  /**
   * 启动ServiceExtensionAbility
   *
   * @param want 数据
   */
  static startServiceExtensionAbility(want: Want): void {
    log.showDebug('startServiceExtensionAbility, bundleName:%{public}s,moduleName:%{public}s,abilityName:%{public}s ',
      want?.bundleName, want?.moduleName, want?.abilityName);
    if (CommonUtils.isInvalid(want)) {
      log.showWarn('startServiceExtensionAbility want is null');
      return;
    }
    let context = GlobalContext.getContext();
    // 自身应用，直接启动
    if (want.bundleName === SCBConstants.SCENE_BOARD_PKG) {
      context?.startServiceExtensionAbility(want);
    } else { // 其他应用，跳转当前用户
      AccountMgr.getCurrentAccountId().then((id) => {
        if (id === AccountConstants.INVALID_ID) {
          context?.startServiceExtensionAbility(want);
        } else {
          context?.startServiceExtensionAbilityWithAccount(want, id);
        }
      });
    }
  }

  /**
   * stop ServiceExtensionAbility
   *
   * @param want data
   */
  static stopServiceExtensionAbility(want: Want): void {
    log.showDebug('stopServiceExtensionAbility, bundleName:%{public}s,moduleName:%{public}s,abilityName:%{public}s ',
      want?.bundleName, want?.moduleName, want?.abilityName);
    if (CommonUtils.isInvalid(want)) {
      log.showWarn('stopServiceExtensionAbility want is null');
      return;
    }
    let context = GlobalContext.getContext();
    if (want.bundleName === SCBConstants.SCENE_BOARD_PKG) {
      context?.stopServiceExtensionAbility(want);
    } else {
      AccountMgr.getCurrentAccountId().then((id) => {
        if (id === AccountConstants.INVALID_ID) {
          context?.stopServiceExtensionAbility(want);
        } else {
          context?.stopServiceExtensionAbilityWithAccount(want, id);
        }
      });
    }
  }

  /**
   * CAMERA预加载需求 AR000HVRQK
   */
  static preLaunchCamera(launchType?: PreLaunchType): void {
    if (this.isPriority) {
      log.showInfo(`preLaunch camera with priority start: ${launchType}`);
      Trace.start('preLaunchCamera');
      preLaunchCameraTask(launchType);
      Trace.end('preLaunchCamera');
      return;
    }
    TaskpoolUtil.doTask(preLaunchCameraTask, launchType);
  }

  /**
   * pair split by want and location
   * pairSpitByLocationAndWant
   * @locationX: Distance from the x-axis of the screen
   * @locationY: Distance from the y-axis of the screen
   * @params paramAbilityName: Ability name
   * @params paramBundleName: Application package name
   * @params paramModuleName: Application module name
   */
  static pairSpitByLocationAndWant(locationX: number, locationY: number, paramAbilityName: string,
    paramBundleName: string, paramModuleName: string, params: Map<string, Object>): void {
    let want: Want = {
      bundleName: paramBundleName,
      abilityName: paramAbilityName,
      moduleName: paramModuleName,
      parameters: { startParams: params, },
    };
    let sceneInfo = new SCBSceneInfo(paramBundleName, paramModuleName, paramAbilityName);
    let queryKey = paramBundleName + paramModuleName + paramAbilityName;
    sceneInfo.launchType = SCBSceneSessionManager.getInstance().getAbilityLaunchType(queryKey);
    sceneInfo.want = want;
    log.showDebug(`pairSpitByLocationAndWant want: ${JSON.stringify(want)}, launchType: ${sceneInfo.launchType}}`);
    SCBSceneSessionManager.getInstance().pairSplitFromDock(locationX, locationY, sceneInfo);
  }

  /**
   * 设置预加载优先级，true时在主线程执行，false时通过taskpool执行
   * @param isPriority
   */
  public static setPreLaunchPriority(isPriority: boolean): void {
    if (this.isPriority === isPriority) {
      return;
    }
    log.showInfo(`set prelaunch camera priority from ${this.isPriority} to ${isPriority}`);
    this.isPriority = isPriority;
  }
}

function preLaunchCameraTask(launchType?: PreLaunchType): void {
  'use concurrent';
  const TAG = 'StartAbilityUtil';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
  log.showInfo('preLaunch camera task start');
  try {
    const cameraManager =
      camera.getCameraManager((GlobalContext.getInstance().getObject('desktopContext')) as featureAbility.Context);
    log.showInfo(`Prelaunch start camera type: ${launchType}`);
    // @ts-ignore
    cameraManager.prelaunch(launchType);
  } catch (e) {
    log.error('Prelaunch start camera failed. error is', e);
  }
}