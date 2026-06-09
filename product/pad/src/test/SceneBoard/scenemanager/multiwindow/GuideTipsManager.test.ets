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
import { beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import {
  GuideTipsManager
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/Guidance/GuideTipsManager';
import {
  GuidanceDialogManager, DialogCallback
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/Guidance/GuidanceDialogManager';
import {
  GuidanceDialogParam,
  DialogType,
  DialogTriggerType
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/Guidance//GuidanceDialogParam';
import { SCBScreenProperty } from '@ohos/windowscene';

let screenProperty: SCBScreenProperty = new SCBScreenProperty();
screenProperty.init();

export function GuideTipsManagerTest() {
  describe('GuideTipsManagerTest_001', () => {
    GuideTipsFloatingTest_01();
    GuideTipsSplitTest_01();
    tryShowTipsTest_01();
  });
}

function GuideTipsSplitTest_01() {
  it ("tryShowTipForSplit_001", Level.LEVEL0, () => {
    GuideTipsManager.tryShowTipForSplit();
    GuideTipsManager.setIsShowTipForSplitTrue();
    GuideTipsManager.setIsShowTipForSplitFalse();
    GuideTipsManager.setIsShowTipForSplitTimeout();
    expect(screenProperty.rotation).assertEqual(0);
  });
}

function GuideTipsFloatingTest_01() {
  it ("tryShowTipForFloating_001", Level.LEVEL0, () => {
    GuideTipsManager.tryShowTipForFloating();
    GuideTipsManager.setIsShowTipForFloatingTrue();
    GuideTipsManager.setIsShowTipForFloatingFalse();
    GuideTipsManager.setIsShowTipForFloatingTimeout();
    GuideTipsManager.setIsShowTipFalse();
    expect(screenProperty.rotation).assertEqual(0);
  });
}

function tryShowTipsTest_01() {
  it("tryShowTipsTest_01", Level.LEVEL0, () => {
    GuideTipsManager.tryShowTips(DialogTriggerType.FLOATING_TO_SPLIT_GUIDE, screenProperty);
    GuideTipsManager.tryShowTips(DialogTriggerType.SPLITING_GUIDE, screenProperty);
    GuideTipsManager.tryShowTips(DialogTriggerType.MID_SCENE_GUIDE, screenProperty);
    GuideTipsManager.tryShowTips(undefined, screenProperty);
    expect(screenProperty.rotation).assertEqual(0);
  });
}