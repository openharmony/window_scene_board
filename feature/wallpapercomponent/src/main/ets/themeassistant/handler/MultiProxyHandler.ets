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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { EngineContainerManager } from '../component/EngineContainerManager';
import { ScbState, ThemeFreezeReason } from '../ThemeConstant';
import { ThemeServiceHelper } from '../ThemeServiceHelper';
import { TsProxyHandler } from './TsProxyHandler';

const TAG: string = 'MultiProxyHandler';
const LOG: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const INNER_PROXY_ID: string = 'InnerProxy';
const OUTER_PROXY_ID: string = 'OuterProxy';

export class MultiProxyHandler {
  public engineStatus: string = INNER_PROXY_ID;

  private static multiProxyHandler: MultiProxyHandler;

  private proxyMap: Map<string, UIExtensionProxy> = new Map;

  private innerSrcState: ScbState = ScbState.LOCKSCREEN;

  private outerSrcState: ScbState = ScbState.LOCKSCREEN;

  private constructor() {
  }

  /**
   * sync state when theme engine switch
   */
  public switchEngineProxy(engine: string): void {
    let state: ScbState = ThemeServiceHelper.getInstance().getScbState();
    if (engine === OUTER_PROXY_ID) {
      this.innerSrcState = state;
      this.engineStatus = OUTER_PROXY_ID;
    } else {
      this.outerSrcState = state;
      this.engineStatus = INNER_PROXY_ID;
    }
    EngineContainerManager.getInstance().setActiveProxy(this.proxyMap.get(engine));
    let srcState: ScbState = engine === OUTER_PROXY_ID ? this.outerSrcState : this.innerSrcState;
    this.proxyMap.get(engine)?.send({
      'scbStateChange': srcState === state,
      'scbState': state,
      'sender': TAG + '_' + engine,
    });
    let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
    if (srcState === state) {
      if (!themeServiceHelper.isOnlineTheme()) {
        this.proxyMap.get(engine)?.send({
          'dynamicAnimation': true,
          'srcState': srcState,
          'dstState': state,
          'isPlayAnimation': false,
          'taskId': -1,
          'sender': TAG + '_' + engine,
        });
      }
    } else {
      this.proxyMap.get(engine)?.send({
        'dynamicAnimation': true,
        'srcState': srcState,
        'dstState': state,
        'isPlayAnimation': true,
        'taskId': -1,
        'sender': TAG + '_' + engine,
      });
    }
    LOG.showInfo(`switchEngineProxy engine:${engine}, srcState:${srcState}, state:${state}`);
    ThemeServiceHelper.getInstance().refreshWallpaperScaleMultiProxy(state, engine);
  };

  /**
   * unfreeze theme engine when exit from EDIT
   */
  public sendUnfreezeStatusForEdit(): void {
    this.proxyMap.forEach((eachProxy: UIExtensionProxy, proxyId: String) => {
      LOG.showInfo(`sendUnfreezeStatusForEdit engine :${proxyId}`);
      new TsProxyHandler(eachProxy).sendEngineFreezeStatusUpdate(false, false);
    });
  }

  /**
   * unfreeze theme engine when exit from drop down
   */
  public sendUnfreezeStatusForDropDown(): void {
    this.proxyMap.forEach((eachProxy: UIExtensionProxy, proxyId: String) => {
      LOG.showInfo(`sendUnfreezeStatusForDropDown engine :${proxyId}`);
      new TsProxyHandler(eachProxy).sendEngineFreezeStatusUpdate(false, false, ThemeFreezeReason.DROPDOWN_PANEL);
    });
  }

  /**
   * unfreeze theme engine
   */
  public sendEngineProxyForActive(engine: string): void {
    LOG.showInfo(`sendEngineProxyForActive engine :${engine}`);
    EngineContainerManager.getInstance().setActiveProxy(this.proxyMap.get(engine));
    ThemeServiceHelper.getInstance().updateScbState(ScbState.PROXIMITY_SCREEN_OFF, ScbState.PROXIMITY_SCREEN_ON,
      () => {}, true);
  };

  /**
   * freeze theme engine
   */
  public sendEngineProxyForSleep(engine: string): void {
    LOG.showInfo(`sendEngineProxyForSleep engine :${engine}`);
    EngineContainerManager.getInstance().setActiveProxy(this.proxyMap.get(engine));
    ThemeServiceHelper.getInstance().updateScbState(ScbState.PROXIMITY_SCREEN_ON, ScbState.PROXIMITY_SCREEN_OFF,
      () => {}, true);
  };

  public sendEngineProxyForSleepById(proxyId: string): void {
    LOG.showInfo(`sendEngineProxyForSleep engine :${proxyId}`);
    let flag: UIExtensionProxy | undefined = this.proxyMap.get(proxyId);
    if (!flag) {
      LOG.warn(TAG, 'Invalid proxy.');
      return;
    }
    new TsProxyHandler(flag).sendEngineFreezeStatusUpdate(true, true);
  };

  /**
   * sync theme engine state when fold to expand
   */
  public syncStateOnSwitchInner(): void {
    this.sendEngineProxyForSleep(OUTER_PROXY_ID);
    this.sendEngineProxyForActive(INNER_PROXY_ID);
    this.switchEngineProxy(INNER_PROXY_ID);
 }

  /**
   * sync theme engine state when expand to fold
   */
  public syncStateOnSwitchOuter(): void {
    this.sendEngineProxyForSleep(INNER_PROXY_ID);
    this.sendEngineProxyForActive(OUTER_PROXY_ID);
    this.switchEngineProxy(OUTER_PROXY_ID);
  }

  /**
   * sync theme engine state when expand to fold but not activate outer
   * proxy due to last inner proxy being frozen
   */
  public syncStateOnSwitchOuterSleep(): void {
    this.sendEngineProxyForSleep(INNER_PROXY_ID);
    this.switchEngineProxy(OUTER_PROXY_ID);
  }

  /**
   * sync theme engine state when fold to expand but not activate inner
   * proxy due to last outer proxy being frozen
   */
  public syncStateOnSwitchInnerSleep(): void {
    this.sendEngineProxyForSleep(OUTER_PROXY_ID);
    this.switchEngineProxy(INNER_PROXY_ID);
  }

  public sendEngineProxyForAOD2Lock(engine: string): void {
    let state: ScbState = ThemeServiceHelper.getInstance().getScbState();
    if (state !== ScbState.AOD) {
      return;
    } else {
      state = ScbState.LOCKSCREEN;
    }
    this.proxyMap.get(engine)?.send({
      'scbStateChange': true,
      'scbState': state,
    });
    LOG.showInfo(`sendEngineProxyForAOD2Lock engine :${engine}`);
    EngineContainerManager.getInstance().setActiveProxy(this.proxyMap.get(engine));
  };

  /**
   * reset inactive theme engine state
   *
   * @param engine engine proxy id
   */
  public setInactiveProxyState(engine: string): void {
    let state: ScbState = ThemeServiceHelper.getInstance().getScbState();
    LOG.showInfo(`setInactiveProxyState engine: ${engine} to state: ${state}`);
    if (engine === OUTER_PROXY_ID) {
      this.outerSrcState = state;
      this.engineStatus = INNER_PROXY_ID;
    } else {
      this.innerSrcState = state;
      this.engineStatus = OUTER_PROXY_ID;
    }
  }

  /**
   * AOD status update
   */
  public sendAodStateUpdate(): void {
    LOG.showInfo(`sendAodStateUpdate`);
    this.proxyMap.get('InnerProxy')?.send({
      'aodStateChange': true,
    });
    this.proxyMap.get('OuterProxy')?.send({
      'aodStateChange': true,
    });
  }

  public registerProxy(key: string, proxy: UIExtensionProxy): void {
    this.proxyMap.set(key, proxy);
  }

  public unregisterProxy(): void {
    this.proxyMap.clear();
  }

  public static getInstance(): MultiProxyHandler {
    if (!MultiProxyHandler.multiProxyHandler) {
      MultiProxyHandler.multiProxyHandler = new MultiProxyHandler();
    }
    return MultiProxyHandler.multiProxyHandler;
  }
}