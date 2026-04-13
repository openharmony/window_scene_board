/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import {
  describe,
  expect,
  it,
  Level
} from '@ohos/hypium';
import { StateMattesSwitchStrategy } from '../../../../main/ets/mattesstrategy/StateMattesSwitchStrategy';
import { MainPageListener } from '../../../../main/ets/mattesstrategy/MattesSwitchStrategy';
import { ArrayList } from '@kit.ArkTS';
import { SCBPropertyChangeReason, ScenePanelState } from '@ohos/windowscene/src/main/ets/TsIndex';

const DIRECT_TO_BOTTOM: number = 0;
const DIRECT_TO_LEFT: number = 90;
const DIRECT_TO_TOP: number = 180;
const DIRECT_TO_RIGHT: number = 270;

let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_TO_EXPAND;
let scenePanelState: ScenePanelState = ScenePanelState.HOME;
let ifAnimatorPlay: boolean = false;

export default function StateMattesSwitchStrategyTest() {
  describe('StateMattesSwitchStrategyTest', () => {
    StateMattesSwitchStrategyTest_01();
    StateMattesSwitchStrategyTest_02();
    StateMattesSwitchStrategyTest_03();
    StateMattesSwitchStrategyTest_04();
    StateMattesSwitchStrategyTest_05();
    StateMattesSwitchStrategyTest_06();
  });
}

export function StateMattesSwitchStrategyTest_01() {
  it('addMainPageListener', Level.LEVEL0, (): void => {
    let testStrategy_01: StateMattesSwitchStrategy = StateMattesSwitchStrategy.getInstance();
    testStrategy_01.mainListenerList = new ArrayList<MainPageListener>();
    let mainPageListener_01: MainPageListener = {
      animatorPlay: (reason, scenePanelState, rotation) => {}
    }
    testStrategy_01.addMainPageListener(mainPageListener_01);
    expect(1).assertEqual(testStrategy_01.mainListenerList.length);
  })
}

export function StateMattesSwitchStrategyTest_02() {
  it('callMainPageListener', Level.LEVEL0, (): void => {
    let testStrategy_02: StateMattesSwitchStrategy = StateMattesSwitchStrategy.getInstance();
    testStrategy_02.mainListenerList = new ArrayList<MainPageListener>();
    ifAnimatorPlay = false;
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.UNDEFINED;
    let scenePanelState: ScenePanelState = ScenePanelState.HOME;
    let rotation: number = DIRECT_TO_BOTTOM;
    let mainPageListener_02: MainPageListener = {
      animatorPlay: (reason, scenePanelState, rotation) => {
        ifAnimatorPlay = true;
      }
    }
    testStrategy_02.mainListenerList.add(mainPageListener_02);
    testStrategy_02.onMainPageRequested(reason, scenePanelState, rotation);
    expect(ifAnimatorPlay).assertTrue();
  })
}

export function StateMattesSwitchStrategyTest_03() {
  it('removeMainPageListener', Level.LEVEL0, (): void => {
    let testStrategy_03: StateMattesSwitchStrategy = StateMattesSwitchStrategy.getInstance();
    testStrategy_03.mainListenerList = new ArrayList<MainPageListener>();
    let mainPageListener_03: MainPageListener = {
      animatorPlay: (reason, scenePanelState, rotation) => {}
    }
    testStrategy_03.mainListenerList.add(mainPageListener_03);
    testStrategy_03.removeMainPageListener(mainPageListener_03);
    expect(0).assertEqual(testStrategy_03.mainListenerList.length);
  })
}

export function StateMattesSwitchStrategyTest_04() {
  it('getCallBackParam01', Level.LEVEL0, (): void => {
    let testStrategy_04: StateMattesSwitchStrategy = StateMattesSwitchStrategy.getInstance();
    testStrategy_04.mainListenerList = new ArrayList<MainPageListener>();
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_TO_EXPAND;
    let scenePanelState: ScenePanelState = ScenePanelState.HOME;
    let rotation: number = DIRECT_TO_BOTTOM;
    let result: SCBPropertyChangeReason = SCBPropertyChangeReason.UNDEFINED;
    let mainPageListener_04: MainPageListener = {
      animatorPlay: (reason, scenePanelState, rotation) => {
        result = reason;
      }
    }
    testStrategy_04.mainListenerList.add(mainPageListener_04);
    testStrategy_04.onMainPageRequested(reason, scenePanelState, rotation);
    expect(result).assertEqual(SCBPropertyChangeReason.FOLD_TO_EXPAND);
  })
}

export function StateMattesSwitchStrategyTest_05() {
  it('getCallBackParam01', Level.LEVEL0, (): void => {
    let testStrategy_04: StateMattesSwitchStrategy = StateMattesSwitchStrategy.getInstance();
    testStrategy_04.mainListenerList = new ArrayList<MainPageListener>();
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_TO_EXPAND;
    let scenePanelState: ScenePanelState = ScenePanelState.SPLIT;
    let rotation: number = DIRECT_TO_BOTTOM;
    let result: ScenePanelState = ScenePanelState.HOME;
    let mainPageListener_04: MainPageListener = {
      animatorPlay: (reason, scenePanelState, rotation) => {
        result = scenePanelState;
      }
    }
    testStrategy_04.mainListenerList.add(mainPageListener_04);
    testStrategy_04.onMainPageRequested(reason, scenePanelState, rotation);
    expect(result).assertEqual(ScenePanelState.SPLIT);
  })
}

export function StateMattesSwitchStrategyTest_06() {
  it('getCallBackParam01', Level.LEVEL0, (): void => {
    let testStrategy_04: StateMattesSwitchStrategy = StateMattesSwitchStrategy.getInstance();
    testStrategy_04.mainListenerList = new ArrayList<MainPageListener>();
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_TO_EXPAND;
    let scenePanelState: ScenePanelState = ScenePanelState.HOME;
    let rotation: number = DIRECT_TO_LEFT;
    let result: number = DIRECT_TO_BOTTOM;
    let mainPageListener_04: MainPageListener = {
      animatorPlay: (reason, scenePanelState, rotation) => {
        result = rotation;
      }
    }
    testStrategy_04.mainListenerList.add(mainPageListener_04);
    testStrategy_04.onMainPageRequested(reason, scenePanelState, rotation);
    expect(result).assertEqual(DIRECT_TO_LEFT);
  })
}

