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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { AnimateToScheduleUtils } from '../../../../../../main/ets/utils/AnimateToScheduleUtils';

const testBundleName = "com.ohos.settings";
const testWrongBundleName = "com.openharmony.xxxx";

export function AnimateToScheduleUtilsTest() {
  describe('AnimateToScheduleUtilsTest', (): void => {
    beforeAll(() => {

    });
    beforeEach(() => {

    });
    afterEach(() => {

    });
    afterAll(() => {

    });
    reportMinimizeToRssTest();
    reportMaximizeToRssTest();
    reportSplitToRssTest();
    reportAppOptFromRecentToRssTest();
    reportSwipeDirectionUpToRssTest();
  });

}

function reportMinimizeToRssTest() {
  it('reportMinimizeToRssTest_01', Level.LEVEL0, (): void => {
    let result = AnimateToScheduleUtils.reportMinimizeToRss(testBundleName);
    expect(result === undefined).assertTrue();
  });
  it('reportMinimizeToRssTest_02', Level.LEVEL0, (): void => {
    let result = AnimateToScheduleUtils.reportMinimizeToRss(testWrongBundleName);
    expect(result === undefined).assertTrue();
  });
}

function reportMaximizeToRssTest() {
  it('reportMaximizeToRssTest_01', Level.LEVEL0, (): void => {
    let result = AnimateToScheduleUtils.reportMaximizeToRss(1, testBundleName);
    expect(result === undefined).assertTrue();
  });
  it('reportMaximizeToRssTest_02', Level.LEVEL0, (): void => {
    let result = AnimateToScheduleUtils.reportMaximizeToRss(2, testWrongBundleName);
    expect(result === undefined).assertTrue();
  });
  it('reportMaximizeToRssTest_03', Level.LEVEL0, (): void => {
    let result = AnimateToScheduleUtils.reportMaximizeToRss(1);
    expect(result === undefined).assertTrue();
  });
  it('reportMaximizeToRssTest_04', Level.LEVEL0, (): void => {
    let result = AnimateToScheduleUtils.reportMaximizeToRss(2);
    expect(result === undefined).assertTrue();
  });
}

function reportSplitToRssTest() {
  it('reportSplitToRssTest_01', Level.LEVEL0, (): void => {
    let result = AnimateToScheduleUtils.reportSplitToRss(0, testBundleName);
    expect(result === undefined).assertTrue();
  });
  it('reportSplitToRssTest_02', Level.LEVEL0, (): void => {
    let result = AnimateToScheduleUtils.reportSplitToRss(1, testWrongBundleName);
    expect(result === undefined).assertTrue();
  });
  it('reportSplitToRssTest_03', Level.LEVEL0, (): void => {
    let result = AnimateToScheduleUtils.reportSplitToRss(0);
    expect(result === undefined).assertTrue();
  });
  it('reportSplitToRssTest_04', Level.LEVEL0, (): void => {
    let result = AnimateToScheduleUtils.reportSplitToRss(1);
    expect(result === undefined).assertTrue();
  });
}

function reportAppOptFromRecentToRssTest() {
  it('reportAppOptFromRecentToRssTest_01', Level.LEVEL0, (): void => {
    let result = AnimateToScheduleUtils.reportAppOptFromRecentToRss(0, testBundleName);
    expect(result === undefined).assertTrue();
  });
  it('reportAppOptFromRecentToRssTest_02', Level.LEVEL0, (): void => {
    let result = AnimateToScheduleUtils.reportAppOptFromRecentToRss(1, testWrongBundleName);
    expect(result === undefined).assertTrue();
  });
  it('reportAppOptFromRecentToRssTest_03', Level.LEVEL0, (): void => {
    let result = AnimateToScheduleUtils.reportAppOptFromRecentToRss(0);
    expect(result === undefined).assertTrue();
  });
  it('reportAppOptFromRecentToRssTest_04', Level.LEVEL0, (): void => {
    let result = AnimateToScheduleUtils.reportAppOptFromRecentToRss(1);
    expect(result === undefined).assertTrue();
  });
}

function reportSwipeDirectionUpToRssTest() {
  it('reportSwipeDirectionUpToRssTest_01', Level.LEVEL0, (): void => {
    let result = AnimateToScheduleUtils.reportSwipeDirectionUpToRss(0);
    expect(result === undefined).assertTrue();
  });
  it('reportSwipeDirectionUpToRssTest_02', Level.LEVEL0, (): void => {
    let result = AnimateToScheduleUtils.reportSwipeDirectionUpToRss(1);
    expect(result === undefined).assertTrue();
  });
}
