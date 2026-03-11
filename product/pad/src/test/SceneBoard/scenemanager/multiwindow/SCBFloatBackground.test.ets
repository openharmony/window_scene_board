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
  SCBDividerParam,
  ScbNumber
} from '@ohos/windowscene';
import { DividerStyleConstants } from '@ohos/commonconstants';
import { DeviceHelper, } from '@ohos/frameworkwrapper';
import { describe, expect, it, Level } from '@ohos/hypium';
import {
  FloatBackgroundParam
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBFloatBackground';

export default function floatBackgroundParamTest() {
  describe('floatBackgroundParamTest_001', () => {
    constructorTest_01();
    obtainTest_01();
    deleteRecordTest_01();
    setScaleTest_01();
    setTranslateTest_01();
    setSizeNumTest_01();
    setPosNumTest_01();
    initFromDividerTest_01();
    copyToTest_01();
  });
}

function obtainTest_01() {
  it('obtainTest_001', Level.LEVEL0, () => {
    let param = FloatBackgroundParam.obtain('test');
    expect(Boolean(param)).assertTrue();
    expect(param.tag).assertEqual('test');
    let oParam = FloatBackgroundParam.obtain('test');
    expect(oParam).assertEqual(param);
    param.deleteRecord();
  });
}

function constructorTest_01() {
  it('constructorTest_001', Level.LEVEL0, () => {
    let param = new FloatBackgroundParam('test');
    expect(param.tag).assertEqual('test');
    expect(param.needShow).assertEqual(false);
    expect(param.posX.getPx()).assertEqual(0);
    expect(param.posY.getPx()).assertEqual(0);
    expect(param.width.getPx()).assertEqual(0);
    expect(param.height.getPx()).assertEqual(0);
    expect(param.borderRadius).assertEqual(DeviceHelper.getDeviceRadius());
    expect(param.alpha).assertEqual(0);
    expect(param.scaleX).assertEqual(0);
    expect(param.scaleY).assertEqual(0);
    expect(param.translateX).assertEqual(0);
    expect(param.translateY).assertEqual(0);
  });
}

function deleteRecordTest_01() {
  it('deleteRecordTest_001', Level.LEVEL0, () => {
    let param = FloatBackgroundParam.obtain('test');
    expect(Boolean(param)).assertTrue();
    let oParam = FloatBackgroundParam.obtain('test');
    expect(oParam).assertEqual(param);
    param.deleteRecord();
    let oParam2 = FloatBackgroundParam.obtain('test');
    expect(oParam2 === param).assertFalse();
    oParam2.deleteRecord();
  });
}

function setTranslateTest_01() {
  it('setTranslateTest_001', Level.LEVEL0, () => {
    let param = new FloatBackgroundParam('test');
    param.setTranslate(50, 30);
    expect(param.translateX).assertEqual(50);
    expect(param.translateY).assertEqual(30);
  });
}

function setScaleTest_01() {
  it('setScaleTest_001', Level.LEVEL0, () => {
    let param = new FloatBackgroundParam('test');
    param.setScale(50, 30);
    expect(param.scaleX).assertEqual(50);
    expect(param.scaleY).assertEqual(30);
  });
}

function setSizeNumTest_01() {
  it('setSizeNumTest_001', Level.LEVEL0, () => {
    let param = new FloatBackgroundParam('test');
    param.setSizeNum(50, 30);
    expect(param.width.getPx()).assertEqual(50);
    expect(param.height.getPx()).assertEqual(30);
  });
}

function initFromDividerTest_01() {
  it('initFromDividerTest_001', Level.LEVEL0, () => {
    let param = new FloatBackgroundParam('test');
    let divider = new SCBDividerParam();
    let screeW = 100;
    let screeH = 100
    let dividerPxHeight = vp2px(DividerStyleConstants.DIVIDER_HEIGHT);
    let targetW = screeW - DividerStyleConstants.DIVIDER_HEIGHT * 2
    let targetH = screeH - DividerStyleConstants.DIVIDER_HEIGHT * 2
    param.initFromDivider(divider, true, screeW, screeH);
    expect(param.posX.getPx()).assertEqual(dividerPxHeight);
    expect(param.posY.getPx()).assertEqual(dividerPxHeight);
    expect(param.width.getPx()).assertEqual(vp2px(targetW));
    expect(param.height.getPx()).assertEqual(vp2px(targetH));
    expect(param.borderRadius).assertEqual(DeviceHelper.getDeviceRadius());
    expect(param.alpha).assertEqual(0);
    expect(param.scaleX).assertEqual(1);
    expect(param.scaleY).assertEqual(1);
  });
}

function setPosNumTest_01() {
  it('setPosNumTest_001', Level.LEVEL0, () => {
    let param = new FloatBackgroundParam('test');
    param.setPosNum(50, 30);
    expect(param.posX.getPx()).assertEqual(50);
    expect(param.posY.getPx()).assertEqual(30);
  });
}

function copyToTest_01() {
  it('copyToTest_001', Level.LEVEL0, () => {
    let param = new FloatBackgroundParam('param');
    param.needShow = true;
    param.posX = new ScbNumber(101);
    param.posY = new ScbNumber(102);
    param.width = new ScbNumber(103);
    param.height = new ScbNumber(104);
    param.borderRadius = 105;
    param.alpha = 3;
    param.scaleX = 4;
    param.scaleY = 5;
    param.translateX = 6;
    param.translateY = 7;
    let target = new FloatBackgroundParam('target');
    param.copyTo(target);
    expect(target.needShow).assertEqual(param.needShow);
    expect(target.posX.getPx()).assertEqual(param.posX.getPx());
    expect(target.posY.getPx()).assertEqual(param.posY.getPx());
    expect(target.width.getPx()).assertEqual(param.width.getPx());
    expect(target.height.getPx()).assertEqual(param.height.getPx());
    expect(target.borderRadius).assertEqual(param.borderRadius);
    expect(target.alpha).assertEqual(param.alpha);
    expect(target.scaleX).assertEqual(param.scaleX);
    expect(target.scaleY).assertEqual(param.scaleY);
    expect(target.translateX).assertEqual(param.translateX);
    expect(target.translateY).assertEqual(param.translateY);
  });
}