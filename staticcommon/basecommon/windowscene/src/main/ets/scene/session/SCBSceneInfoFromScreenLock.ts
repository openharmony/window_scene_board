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

import { SCBSceneInfo } from '../session/SCBSceneInfo';
import type { Callback } from '@ohos.base';
import { RectInfo } from '@ohos/basicutils';
import { image } from '@kit.ImageKit';

export class SCBSceneInfoFromScreenLock extends SCBSceneInfo {
  originIconInfo: IconInfoFromScreenLock = new IconInfoFromScreenLock();
  callback: CallbackFromScreenLock;

  moveStartingOption: MoveStartingOption | null = null;

  constructor(bundleName: string, moduleName: string, abilityName: string) {
    super(bundleName, moduleName, abilityName);
  }
  public getSceneFromScreenLock(): SCBSceneInfoFromScreenLock | null {
    return this;
  }

  public updateSceneInfo(sceneInfo: SCBSceneInfo): void {
    this.unclearableSession = sceneInfo.unclearableSession;
    this.appIndex = sceneInfo.appIndex;
    this.screenId = sceneInfo.screenId;
    this.persistentId = sceneInfo.persistentId;
    this.callerPersistentId = sceneInfo.callerPersistentId;
    this.callerBundleName = sceneInfo.callerBundleName;
    this.callerAbilityName = sceneInfo.callerAbilityName;
    this.toPersistentId = sceneInfo.toPersistentId;
    this.launchType = sceneInfo.launchType;
    this.callState = sceneInfo.callState;
    this.isNewInstance = sceneInfo.isNewInstance;
    this.rotationStrategy = sceneInfo.rotationStrategy;
    this.isClearSession = sceneInfo.isClearSession;
    this.isPersistentRecover = sceneInfo.isPersistentRecover;
    this.windowTop = sceneInfo.windowTop;
    this.windowLeft = sceneInfo.windowLeft;
    this.windowWidth = sceneInfo.windowWidth;
    this.windowHeight = sceneInfo.windowHeight;
    this.withAnimation = sceneInfo.withAnimation;
    this.focusedOnShow = sceneInfo.focusedOnShow;
    this.isCastScene = sceneInfo.isCastScene;
    this.isStartByLaunchTypeConfig = sceneInfo.isStartByLaunchTypeConfig;
    this.isCalledRightlyByCallerId = sceneInfo.isCalledRightlyByCallerId;
    this.updateWindowModeAndSync(sceneInfo.windowMode);
  }

  public updateMoveStartingOption(option: MoveStartingOption | null): void {
    this.moveStartingOption = option;
  }

  public clearMoveStartingOption(): void {
    this.moveStartingOption = null;
  }
}

export class IconInfoFromScreenLock {
  public image: Resource;
  public backplaneOpacity: number = 0;
  public pointLight = {};
  public bgWidth: number = 0;
  public bgHeight: number = 0;
  public imgWidth: number = 0;
  public imgHeight: number = 0;
  public opacity: number = 0;
  public fillColor: ResourceColor = '#FFFFFFFF';
  public scale: number = 0;
  public iconScale: number = 1;
  public position = {
    x: 0, y: 0
  };
  public borderRadius = 0;
  public backgroundEffect: BackgroundEffectOptions | undefined = undefined;
  public backgroundBrightness: BrightnessOptions | undefined = undefined;
  public backgroundColor: ResourceColor = '#FFFFFFFF';
  public isBackgroundEffect: boolean = true;
  public isAddBrightness: boolean = false;
  public iconBackgroundBrightness: BrightnessOptions | undefined = undefined;
  public iconAddBackgroundBrightness: BrightnessOptions | undefined = undefined;
  public isHit: boolean = false;
}

export class MoveStartingOption {
  public iconScale: number = 1;
  public iconPosition = {
    x: 0, y: 0
  };
  public windowScale: number = 1;
  public windowTranslateX: number = 0;
  public windowTranslateY: number = 0;
}

export interface CallbackFromScreenLock {
  getMinimizeIcon: () => IconInfoFromScreenLock; //返回后锁屏上图标的builder
  minimizeFinish: Callback<void>; //通过手势back/home最小化到原始图标动效结束的回调
  onMinimizeAnimEvent: (isMoveRollback: boolean) => void;
  onSceneProxyReady: (proxy: SceneProxyToScreenLock) => void;
}

export interface SceneProxyToScreenLock {
  onOverThresholdMovingWindow: (scale: number, translateX: number, translateY: number) => void;
  onCrossingThresholdChanged: (isOverThreshold: boolean) => void;
  onRollbackMovingWindow: (movingOption: MoveStartingOption) => void;
  onEndMoveWindow: (isOpen: boolean) => void;
}