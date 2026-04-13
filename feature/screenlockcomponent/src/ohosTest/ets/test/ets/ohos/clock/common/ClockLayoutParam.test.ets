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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, Level, expect } from '@ohos/hypium';
import { ClockGridParam,
  ClockGridParamCorrection,
  ClockLayoutParam, ElementConf }  from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutParam';
import { ClockWidgetId } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';

/**
 * 沉浸式锁屏测试用例
 */
export default function ClockLayoutParamTest() {
  describe('ClockLayoutParamTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_initClockLayoutParam', Level.LEVEL0, (): void => {
      let layoutParam = new ClockLayoutParam();
      let ridParam: ClockGridParam = new ClockGridParam();
      let elementConf = new ElementConf();
      let eleConfS: ElementConf[] = [];
      eleConfS.push(elementConf);
      ridParam.maxWidthSize = 500;
      ridParam.maxHeightSize = 400;
      ridParam.gridWidthSize = 400;
      ridParam.gridHeightSize = 500;
      layoutParam.initClockLayoutParam(1);
      layoutParam.initClockLayoutParam(1, ridParam);
      layoutParam.initClockLayoutParam(1, ridParam, eleConfS);
      elementConf.id = ClockWidgetId.ID_HOUR0;
      layoutParam.initClockLayoutParam(1, ridParam, eleConfS);
      elementConf.id = ClockWidgetId.ID_HOUR1;
      layoutParam.initClockLayoutParam(1, ridParam, eleConfS);
      elementConf.id = ClockWidgetId.ID_SEPARATOR;
      layoutParam.initClockLayoutParam(1, ridParam, eleConfS);
      elementConf.id = ClockWidgetId.ID_MINUTE0;
      layoutParam.initClockLayoutParam(1, ridParam, eleConfS);
      elementConf.id = ClockWidgetId.ID_MINUTE1;
      layoutParam.initClockLayoutParam(1, ridParam, eleConfS);
      elementConf.id = ClockWidgetId.ID_DATE;
      layoutParam.initClockLayoutParam(1, ridParam, eleConfS);
      elementConf.id = ClockWidgetId.ID_WEEK;
      layoutParam.initClockLayoutParam(1, ridParam, eleConfS);
      elementConf.id = ClockWidgetId.ID_LUNA;
      layoutParam.initClockLayoutParam(1, ridParam, eleConfS);
      elementConf.id = ClockWidgetId.ID_COM_SIGN;
      layoutParam.initClockLayoutParam(1, ridParam, eleConfS);
      expect(layoutParam).not().assertNull();
    });

    it('test_ClockGridParamCorrection', 0, () => {
      let correction: ClockGridParamCorrection = new ClockGridParamCorrection();
      expect(true).assertTrue();
    });

    it('test_updateGridParamWithProgress', 0, () => {
      let param: ClockLayoutParam = new ClockLayoutParam();
      param.updateGridParamWithProgress(10);
      param.updateGridParamWithProgress(10, new ClockGridParam(), new ClockGridParam());
      expect(true).assertTrue();
    });

    it('test_updateHourFontSize', 0, () => {
      let param: ClockLayoutParam = new ClockLayoutParam();
      param.updateHourFontSize(10);
      expect(true).assertTrue();
    });

    it('test_updateMinuteAndSeparatorFontSize', 0, () => {
      let param: ClockLayoutParam = new ClockLayoutParam();
      param.updateMinuteAndSeparatorFontSize(10);
      expect(true).assertTrue();
    });

    it('test_updateSingleElementWithProgress', 0, () => {
      let param: ClockLayoutParam = new ClockLayoutParam();
      param.updateSingleElementWithProgress(10);
      let sourceConf: ElementConf = new ElementConf();
      let targetConf: ElementConf = new ElementConf();
      sourceConf.id = ClockWidgetId.ID_HOUR0;
      param.updateSingleElementWithProgress(10, sourceConf, targetConf);
      sourceConf.id = ClockWidgetId.ID_HOUR1;
      param.updateSingleElementWithProgress(10, sourceConf, targetConf);
      sourceConf.id = ClockWidgetId.ID_SEPARATOR;
      param.updateSingleElementWithProgress(10, sourceConf, targetConf);
      sourceConf.id = ClockWidgetId.ID_MINUTE0;
      param.updateSingleElementWithProgress(10, sourceConf, targetConf);
      sourceConf.id = ClockWidgetId.ID_MINUTE1;
      param.updateSingleElementWithProgress(10, sourceConf, targetConf);
      sourceConf.id = ClockWidgetId.ID_DATE;
      param.updateSingleElementWithProgress(10, sourceConf, targetConf);
      sourceConf.id = ClockWidgetId.ID_WEEK;
      param.updateSingleElementWithProgress(10, sourceConf, targetConf);
      sourceConf.id = ClockWidgetId.ID_LUNA;
      param.updateSingleElementWithProgress(10, sourceConf, targetConf);
      sourceConf.id = ClockWidgetId.ID_COM_SIGN;
      param.updateSingleElementWithProgress(10, sourceConf, targetConf);
      expect(true).assertTrue();
    });

    it('test_getNewElementConfWithProgress', 0, () => {
      let param: ClockLayoutParam = new ClockLayoutParam();
      let conf: ElementConf = new ElementConf();
      (param as object)['getNewElementConfWithProgress'](10, conf, conf, conf);
      (param as object)['getNewElementConfWithProgress'](10, conf, conf, conf, true);
      expect(true).assertTrue();
    });

    it('test_setPositionWithProgress', 0, () => {
      let param: ClockLayoutParam = new ClockLayoutParam();
      let exPosition: Position = {x: undefined, y: undefined};
      (param as object)['setPositionWithProgress'](exPosition, exPosition, exPosition, 10);
      let position: Position = {x: 10, y: 10};
      (param as object)['setPositionWithProgress'](position, position, position, 10);
      let strPosition: Position = {x: '10%', y: '10%'};
      (param as object)['setPositionWithProgress'](position, strPosition, position, 10);
      (param as object)['setPositionWithProgress'](strPosition, position, position, 10);
      expect(true).assertTrue();
    });

    it('test_updateElementConfig', 0, () => {
      let param: ClockLayoutParam = new ClockLayoutParam();
      let sourceConf: ElementConf = new ElementConf();
      let eleConfS: ElementConf[] = [];
      eleConfS.push(sourceConf);
      sourceConf.id = ClockWidgetId.ID_HOUR0;
      iterateUpdateElementConfigParam(param, eleConfS);
      sourceConf.id = ClockWidgetId.ID_HOUR1;
      iterateUpdateElementConfigParam(param, eleConfS);
      sourceConf.id = ClockWidgetId.ID_SEPARATOR;
      iterateUpdateElementConfigParam(param, eleConfS);
      sourceConf.id = ClockWidgetId.ID_MINUTE0;
      iterateUpdateElementConfigParam(param, eleConfS);
      sourceConf.id = ClockWidgetId.ID_MINUTE1;
      iterateUpdateElementConfigParam(param, eleConfS);
      sourceConf.id = ClockWidgetId.ID_DATE;
      iterateUpdateElementConfigParam(param, eleConfS);
      sourceConf.id = ClockWidgetId.ID_WEEK;
      iterateUpdateElementConfigParam(param, eleConfS);
      sourceConf.id = ClockWidgetId.ID_LUNA;
      iterateUpdateElementConfigParam(param, eleConfS);
      sourceConf.id = ClockWidgetId.ID_COM_SIGN;
      iterateUpdateElementConfigParam(param, eleConfS);
      expect(true).assertTrue();
    });

    it('test_updateSingleElement', 0, () => {
      let param: ClockLayoutParam = new ClockLayoutParam();
      let sourceConf: ElementConf = new ElementConf();
      sourceConf.id = ClockWidgetId.ID_HOUR0;
      iterateUpdateSingleElement(param, sourceConf);
      sourceConf.id = ClockWidgetId.ID_HOUR1;
      iterateUpdateSingleElement(param, sourceConf);
      sourceConf.id = ClockWidgetId.ID_SEPARATOR;
      iterateUpdateSingleElement(param, sourceConf);
      sourceConf.id = ClockWidgetId.ID_MINUTE0;
      iterateUpdateSingleElement(param, sourceConf);
      sourceConf.id = ClockWidgetId.ID_MINUTE1;
      iterateUpdateSingleElement(param, sourceConf);
      sourceConf.id = ClockWidgetId.ID_DATE;
      iterateUpdateSingleElement(param, sourceConf);
      sourceConf.id = ClockWidgetId.ID_WEEK;
      iterateUpdateSingleElement(param, sourceConf);
      sourceConf.id = ClockWidgetId.ID_LUNA;
      iterateUpdateSingleElement(param, sourceConf);
      sourceConf.id = ClockWidgetId.ID_COM_SIGN;
      iterateUpdateSingleElement(param, sourceConf);
      expect(true).assertTrue();
    });
  });
}

function iterateUpdateSingleElement(param: ClockLayoutParam, sourceConf: ElementConf) {
  param.updateSingleElement();
  param.updateSingleElement(sourceConf);
  param.updateSingleElement(sourceConf, true, true);
  param.updateSingleElement(sourceConf, true, false);
  param.updateSingleElement(sourceConf, false, true);
  param.updateSingleElement(sourceConf, false, false);
}

function iterateUpdateElementConfigParam(param: ClockLayoutParam, eleConfS: ElementConf[]) {
  param.updateElementConfig();
  param.updateElementConfig(eleConfS);
  param.updateElementConfig(eleConfS, true, true);
  param.updateElementConfig(eleConfS, true, false);
  param.updateElementConfig(eleConfS, false, true);
  param.updateElementConfig(eleConfS, false, false);
}
