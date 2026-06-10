/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
import { CheckEmptyUtils } from '@ohos/basicutils';

import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  Level,
  MockKit,
  when
} from '@ohos/hypium';
import { BaseBundleInfo } from '../../../../../../main/ets/bean/BaseBundleInfo';
import {
  BadgeItemInfo,
  BadgeListener,
  BadgeManager,
  CustomBadgeManager,
  DefineBadgePostion,
  EventConstants,
  RdbStoreManager,
  StyleConstants
} from '../../../../../../main/ets/TsIndex';

export default function BadgeManagerTest() {
  describe('BadgeManagerTest', (): void => {
    const badgeManager = BadgeManager.getInstance();
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterAll((): void => {
    })

    afterEach((): void => {
    })

    it('test_getAllBadge', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      expect(badgeList).not().assertNull();
      done();
    })

    it('test_getBadgeByBundleSync', Level.LEVEL0, async (done: Function) => {
      try {
        const badgeList = await badgeManager.getAllBadge();
        if (badgeList.length > 0) {
          const num = await badgeManager.getBadgeByBundleSync(badgeList[0]);
          expect(badgeList[0].badgeNumber).assertEqual(num);
        }
      } catch (e) {
      }
      done();
    })

    it('test_getBadgeByBundle', Level.LEVEL0, async (done: Function) => {
      try {
        const badgeList = await badgeManager.getAllBadge();
        if (badgeList.length > 0) {
          await badgeManager.getBadgeByBundle(badgeList[0], (num) => {
            expect(badgeList[0].badgeNumber).assertEqual(num);
          });
        }
      } catch (e) {
      }
      done();
    })

    it('test_getBadgeDisplayByBundleSync', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        const isShow = await badgeManager.getBadgeDisplayByBundleSync(badgeList[0]);
        expect(isShow).assertEqual(badgeList[0].isShow);
      }
      done();
    })

    it('test_getBadgeDisplayNumberByBundle', Level.LEVEL0, async (done: Function) => {
      try {
        const badgeList = await badgeManager.getAllBadge();
        if (badgeList.length > 0) {
          await badgeManager.getBadgeDisplayNumberByBundle(badgeList[0], (isShow) => {
            let a = 'test';
            expect(a).assertEqual('test');
            //expect(isShow).assertEqual(badgeList[0].isShow);
          });
        }
      } catch (e) {
      }
      done();
    })

    it('test_updateBadgeNumber', Level.LEVEL0, async (done: Function) => {
      try {
        const badgeList = await badgeManager.getAllBadge();
        if (badgeList.length > 0) {
          let ret = await badgeManager.updateBadgeNumber(badgeList[0], -1);
          expect(ret).assertEqual(false);
          ret = await badgeManager.updateBadgeNumber({
            bundleName: '', appIndex: 0
          }, 1);
          expect(ret).assertEqual(false);
          ret = await badgeManager.updateBadgeNumber(undefined, 1);
          expect(ret).assertEqual(false);
          ret = await badgeManager.updateBadgeNumber(badgeList[0], badgeList[0].badgeNumber);
          expect(ret).assertEqual(true);
          ret = await badgeManager.updateBadgeNumber(badgeList[0], 1);
          ret = await badgeManager.updateBadgeNumber(badgeList[0], 80);
          expect(ret).assertEqual(true);
          ret = await badgeManager.updateBadgeNumber(badgeList[0], 90);
          expect(ret).assertEqual(true);
        }
      } catch (e) {
      }
      done();
    })

    it('test_updateBadgeNumber_1', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret = await badgeManager.updateBadgeNumber(badgeList[0], -1);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber({
          bundleName: '', appIndex: 0
        }, 1);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber(undefined, 1);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], badgeList[0].badgeNumber);
        expect(ret).assertEqual(true);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], 11);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], 12);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], 23);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], 34);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], 45);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], 56);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], 67);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], 78);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], 89);
        expect(ret).assertEqual(true);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], 90);
        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_updateBadgeNumber_2', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret = await badgeManager.updateBadgeNumber(badgeList[0], -1);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber({
          bundleName: '', appIndex: 0
        }, 1);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber(undefined, 1);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], badgeList[0].badgeNumber);
        expect(ret).assertEqual(true);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], -1);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], -2);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], -3);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], -4);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], -5);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], -6);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], 90);
        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_updateBadgeNumber_3', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret = await badgeManager.updateBadgeNumber(badgeList[0], -1);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber({
          bundleName: '', appIndex: 0
        }, 1);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber(undefined, 1);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], badgeList[0].badgeNumber);
        expect(ret).assertEqual(true);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], -11);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], -22);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], -33);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], -44);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], -55);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], -67);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], -78);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], -89);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], -91);
        expect(ret).assertEqual(false);
        ret = await badgeManager.updateBadgeNumber(badgeList[0], 90);
        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_updateBadgeDisplay', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret = await badgeManager.updateBadgeDisplay(badgeList[0], badgeList[0].isShow);
        expect(ret).assertEqual(true);
        ret = await badgeManager.updateBadgeDisplay(badgeList[0], !badgeList[0].isShow);
        expect(ret).assertEqual(true);
      }
      done();
    })


    it('test_registerAppListEvent', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret: boolean = true;
        badgeManager.registerAppListEvent();
        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_unregisterAppListEvent', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret: boolean = true;
        badgeManager.unregisterAppListEvent();
        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_registerBadgeListener', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret: boolean = true;
        badgeManager.registerBadgeListener({
          bundleName: '', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'a', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'b', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'c', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'd', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'e', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'f', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'g', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'h', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'i', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'j', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'k', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'l', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'm', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'n', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'o', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'p', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'q', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'r', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 's', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 't', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'test1', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'test2', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'test3', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'test4', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'test5', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'test6', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'test7', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'test8', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'test9', appIndex: 0
        }, null);
        badgeManager.registerBadgeListener({
          bundleName: 'test10', appIndex: 0
        }, null);

        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_registerBadgeListener_2', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret: boolean = true;
        let badgeListener: BadgeListener = {
          onUpdate: (badgeInfo: BadgeItemInfo) => {
          }
        };
        badgeManager.registerBadgeListener({
          bundleName: '', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'a', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'b', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'c', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'd', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'e', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'f', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'g', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'h', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'i', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'j', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'k', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'l', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'm', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'n', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'o', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'p', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'q', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'r', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 's', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 't', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'test1', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'test2', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'test3', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'test4', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'test5', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'test6', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'test7', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'test8', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'test9', appIndex: 0
        }, badgeListener);
        badgeManager.registerBadgeListener({
          bundleName: 'test10', appIndex: 0
        }, badgeListener);
        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_unRegisterBadgeListener', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret: boolean = true;
        badgeManager.unRegisterBadgeListener({
          bundleName: '', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'a', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'b', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'c', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'd', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'e', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'f', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'g', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'h', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'i', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'j', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'k', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'l', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'm', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'n', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'o', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'p', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'q', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'r', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 's', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 't', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test1', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test2', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test3', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test4', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test5', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test6', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test7', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test8', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test9', appIndex: 0
        }, null);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test10', appIndex: 0
        }, null);
        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_unRegisterBadgeListener_2', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret: boolean = true;
        let badgeListener: BadgeListener = {
          onUpdate: (badgeInfo: BadgeItemInfo) => {
          }
        };
        badgeManager.unRegisterBadgeListener({
          bundleName: '', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'a', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'b', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'c', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'd', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'e', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'f', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'g', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'h', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'i', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'j', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'k', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'l', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'm', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'n', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'o', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'p', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'q', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'r', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 's', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 't', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test1', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test2', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test3', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test4', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test5', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test6', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test7', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test8', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test9', appIndex: 0
        }, badgeListener);
        badgeManager.unRegisterBadgeListener({
          bundleName: 'test10', appIndex: 0
        }, badgeListener);
        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_getTextWidth', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret: boolean = true;
        let textWidth: number = badgeManager.getTextWidth('1', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '12');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '20');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '17');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '14');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '11');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '12');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('14', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('17', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('13', '1');
        expect(textWidth >= 0).assertEqual(true);
        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_getTextWidth_2', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret: boolean = true;
        let textWidth: number = badgeManager.getTextWidth('1', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('11', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('12', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('13', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '14');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '41');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '21');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('21', '41');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '51');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '61');
        expect(textWidth >= 0).assertEqual(true);
        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_getTextWidth_3', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret: boolean = true;
        let textWidth: number = badgeManager.getTextWidth('1', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('11', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('12', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('13', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '14');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '41');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '21');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('21', '41');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '51');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '61');
        expect(textWidth >= 0).assertEqual(true);
        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_getTextWidth_4', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret: boolean = true;
        let textWidth: number = badgeManager.getTextWidth('1', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('11', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('12', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('13', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '14');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '41');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '21');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('21', '41');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '51');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '61');
        expect(textWidth >= 0).assertEqual(true);
        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_getTextWidth_5', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret: boolean = true;
        let textWidth: number = badgeManager.getTextWidth('1', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('11', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('12', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('13', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '14');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '1');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '41');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '21');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('21', '41');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '51');
        expect(textWidth >= 0).assertEqual(true);
        textWidth = badgeManager.getTextWidth('1', '61');
        expect(textWidth >= 0).assertEqual(true);
        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_getBadgeOffsetX', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret: boolean = true;
        let offsetX: number = badgeManager.getBadgeOffsetX(10, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(10, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(11, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(12, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(13, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(14, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(15, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(16, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(17, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(18, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(19, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(20, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(21, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        badgeManager.getBadgeOffsetX(2, 0, 0);
        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_getBadgeOffsetX_2', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret: boolean = true;
        let offsetX: number = badgeManager.getBadgeOffsetX(10, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(10, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(11, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(12, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(13, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(14, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(15, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(16, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(17, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(18, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(19, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(20, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(21, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        badgeManager.getBadgeOffsetX(2, 0, 0);
        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_getBadgeOffsetX_3', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret: boolean = true;
        let offsetX: number = badgeManager.getBadgeOffsetX(10, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_getBadgeOffsetX_4', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret: boolean = true;
        let offsetX: number = badgeManager.getBadgeOffsetX(10, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(10, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(11, 11, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(12, 12, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(13, 13, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(14, 14, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(15, 15, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(16, 16, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(17, 17, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(18, 18, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(19, 19, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(20, 20, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(21, 30, 10);
        expect(offsetX >= 0).assertEqual(false);
        badgeManager.getBadgeOffsetX(2, 0, 0);
        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_getBadgeOffsetX_5', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let ret: boolean = true;
        let offsetX: number = badgeManager.getBadgeOffsetX(10, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(101, 10, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(112, 11, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(123, 12, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(134, 13, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(145, 14, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(156, 15, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(167, 16, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(178, 17, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(189, 18, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(190, 19, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(200, 20, 10);
        expect(offsetX >= 0).assertEqual(false);
        offsetX = badgeManager.getBadgeOffsetX(211, 30, 10);
        expect(offsetX >= 0).assertEqual(false);
        badgeManager.getBadgeOffsetX(2, 0, 0);
        expect(ret).assertEqual(true);
      }
      done();
    })

    it('test_getBadgePostion', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let result: DefineBadgePostion = badgeManager.getBadgePostion(2, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(3, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(4, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(5, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(6, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(7, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(8, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(9, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(10, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(11, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(12, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(13, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(14, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(15, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(16, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(17, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(18, 0, 0);
        expect(result.y < 0).assertEqual(true);
      }
      done();
    })

    it('test_getBadgePostion_2', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let result: DefineBadgePostion = badgeManager.getBadgePostion(2, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(3, 1, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(4, 2, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(5, 3, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(6, 4, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(7, 5, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(8, 6, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(9, 7, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(10, 8, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(11, 9, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(12, 10, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(13, 11, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(14, 12, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(15, 13, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(16, 14, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(17, 15, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(18, 16, 0);
        expect(result.y < 0).assertEqual(true);
      }
      done();
    })

    it('test_getBadgePostion_3', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let result: DefineBadgePostion = badgeManager.getBadgePostion(2, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(3, 1, 1);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(4, 2, 2);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(5, 3, 3);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(6, 4, 4);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(7, 5, 5);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(8, 6, 6);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(9, 7, 7);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(10, 8, 8);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(11, 9, 9);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(12, 10, 10);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(13, 11, 11);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(14, 12, 12);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(15, 13, 13);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(16, 14, 14);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(17, 15, 15);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(18, 16, 16);
        expect(result.y < 0).assertEqual(true);
      }
      done();
    })

    it('test_getBadgePostion_4', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let result: DefineBadgePostion = badgeManager.getBadgePostion(2, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(31, 1, 1);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(42, 2, 2);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(53, 3, 3);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(46, 4, 4);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(74, 5, 5);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(85, 6, 6);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(96, 7, 7);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(10, 8, 8);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(11, 9, 9);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(12, 10, 10);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(13, 151, 11);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(14, 12, 12);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(15, 13, 13);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(16, 14, 14);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(17, 15, 15);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(18, 16, 16);
        expect(result.y < 0).assertEqual(true);
      }
      done();
    })

    it('test_getBadgePostion_5', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let result: DefineBadgePostion = badgeManager.getBadgePostion(2, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(31, 12, 1);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(42, 21, 2);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(53, 13, 3);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(46, 4, 3);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(74, 5, 5);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(85, 61, 6);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(96, 7, 7);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(10, 8, 8);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(11, 9, 19);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(12, 10, 10);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(13, 151, 11);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(14, 12, 22);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(15, 13, 13);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(16, 14, 17);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(17, 15, 18);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(18, 18, 16);
        expect(result.y < 0).assertEqual(true);
      }
      done();
    })

    it('test_getBadgePostion_6', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let result: DefineBadgePostion = badgeManager.getBadgePostion(2, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(31, 12, 12);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(42, 21, 21);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(53, 13, 13);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(46, 4, 13);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(74, 5, 15);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(85, 61, 16);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(96, 7, 17);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(10, 8, 18);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(11, 9, 20);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(12, 10, 11);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(13, 151, 21);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(14, 12, 23);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(15, 13, 23);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(16, 14, 27);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(17, 15, 28);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(18, 18, 26);
        expect(result.y < 0).assertEqual(true);
      }
      done();
    })

    it('test_getBadgePostion_7', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let result: DefineBadgePostion = badgeManager.getBadgePostion(2, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(31, 12, 121);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(42, 21, 212);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(53, 13, 133);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(46, 4, 134);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(74, 5, 155);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(85, 61, 166);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(96, 7, 177);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(10, 8, 188);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(11, 9, 208);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(12, 10, 119);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(13, 151, 210);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(14, 12, 231);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(15, 13, 232);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(16, 14, 273);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(17, 15, 284);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(18, 18, 265);
        expect(result.y < 0).assertEqual(true);
      }
      done();
    })

    it('test_getBadgePostion_8', Level.LEVEL0, async (done: Function) => {
      const badgeList = await badgeManager.getAllBadge();
      if (badgeList.length > 0) {
        let result: DefineBadgePostion = badgeManager.getBadgePostion(2, 0, 0);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(31, 122, 121);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(42, 221, 212);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(53, 132, 133);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(46, 42, 134);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(74, 52, 155);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(85, 261, 166);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(96, 27, 177);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(10, 28, 188);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(11, 29, 208);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(12, 102, 119);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(13, 152, 210);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(14, 122, 231);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(15, 132, 232);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(16, 142, 273);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(17, 152, 284);
        expect(result.y < 0).assertEqual(true);
        result = badgeManager.getBadgePostion(18, 182, 265);
        expect(result.y < 0).assertEqual(true);
      }
      done();
    })

    it('testBadgeManager_isCacheExist', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const CACHE_INIT = 0;
      const CACHE_LOADED = 2;
      const mCacheState = badgeManager['mCacheState'];
      const getAllBadge = mocker.mockFunc(badgeManager, badgeManager['getAllBadge']);
      badgeManager['mCacheState'] = CACHE_INIT;
      when(getAllBadge)().afterReturn(Promise.resolve());
      expect(badgeManager['isCacheExist']()).assertFalse();
      expect(badgeManager['isCacheExist']()).assertFalse();
      badgeManager['mCacheState'] = CACHE_LOADED;
      expect(badgeManager['isCacheExist']()).assertTrue();
      badgeManager['mCacheState'] = mCacheState;
      mocker.clear(badgeManager);
      mocker.clearAll();
      done();
    })

    it('testBadgeManager_appRemovedCallBack', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const key: string = 'cacheKey';
      const getCacheKey = mocker.mockFunc(badgeManager, badgeManager['getCacheKey']);
      mocker.mockFunc(badgeManager['mDbStoreManager'], badgeManager['mDbStoreManager'].deleteBadgeByBundle);
      mocker.mockFunc(badgeManager['mBadgeCache'], badgeManager['mBadgeCache'].delete);
      mocker.mockFunc(CustomBadgeManager.getInstance(), CustomBadgeManager.getInstance().clearAppStarBadge);
      when(getCacheKey)(ArgumentMatchers.anyObj).afterReturn(key);
      await badgeManager['appRemovedCallBack'](EventConstants.EVENT_PACKAGE_REMOVED, 'com.ohos.contacts', 899, 899)
      mocker.verify('delete', [key]).once();
      mocker.clear(badgeManager);
      mocker.clear(badgeManager['mDbStoreManager']);
      mocker.clear(badgeManager['mBadgeCache']);
      mocker.clear(CustomBadgeManager.getInstance());
      mocker.clearAll();
      done();
    })

    it('testBadgeManager_ifStringIsNull', Level.LEVEL0, async (done: Function) => {
      expect(badgeManager['ifStringIsNull'](null)).assertTrue();
      expect(badgeManager['ifStringIsNull'](void 0)).assertTrue();
      expect(badgeManager['ifStringIsNull']('')).assertTrue();
      expect(badgeManager['ifStringIsNull']('test')).assertFalse();
      done();
    })

    it('test_getAllBadge_foreach_001', Level.LEVEL0, async (done: Function) => {
      let mDbStoreManager: RdbStoreManager = badgeManager['mDbStoreManager'];
      if (!mDbStoreManager) {
        mDbStoreManager = RdbStoreManager.getInstance();
      }
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mDbStoreManager, mDbStoreManager.getAllBadge);
      let items: BadgeItemInfo[] = [];
      let item1: BadgeItemInfo = new BadgeItemInfo();
      item1.bundleName = 'badgeName';
      item1.appIndex = 0;
      items.push(item1);
      let item2: BadgeItemInfo = new BadgeItemInfo();
      item2.bundleName = 'badgeName1';
      item2.appIndex = 0;
      items.push(item2);
      when(mockFunc)().afterReturn(items);
      try {
        let res = await badgeManager.getAllBadge();
        expect(res.length > 0).assertTrue();
      } catch (e) {
      }
      mocker.clear(mDbStoreManager);
      mocker.clearAll();
      done();
    })

    it('test_set_getCacheBundleBadge_foreach_001', 0, async (done: Function) => {
      let bundleInfo: BaseBundleInfo = {
        bundleName: 'testBadgeInfoName_001',
        appIndex: 0
      };
      badgeManager.setCacheBundleBadge(bundleInfo, 1, false);
      expect(badgeManager['mBadgeCache']).not().assertUndefined();
      badgeManager.setCacheBundleBadge(bundleInfo, 2, false);
      expect(badgeManager['mBadgeCache']).not().assertUndefined();
      let cacheNum = await badgeManager.getCacheBundleBadge(bundleInfo);
      expect(cacheNum >= 0).assertTrue();
      let bundleInfo1: BaseBundleInfo = {
        bundleName: 'newTestBundleName_0012',
        appIndex: 0
      };
      let cacheNum1 = await badgeManager.getCacheBundleBadge(bundleInfo1);
      expect(cacheNum >= 0).assertTrue();
      let notExist_bundleInfo: BaseBundleInfo = {
        bundleName: 'newBundleName_0012asd',
        appIndex: 0
      };
      let taskRes = badgeManager.getBadgeUpdateTask(notExist_bundleInfo);
      expect(taskRes).assertFalse();
      let taskRes1 = badgeManager.getBadgeUpdateTask(bundleInfo);
      expect(taskRes1).assertFalse();
      done();
    })

    it('test_setBadgeUpdateTask_001', 0, async (done: Function) => {
      let bundleInfo: BaseBundleInfo = {
        bundleName: 'testBadgeInfoName_001',
        appIndex: 0
      };
      badgeManager.setCacheBundleBadge(bundleInfo, 1, false);
      await badgeManager.setBadgeUpdateTask(bundleInfo, false);
      expect(badgeManager['mBadgeCache'].size > 0).assertTrue();
      let notexist_bundleInfo: BaseBundleInfo = {
        bundleName: 'newTestBundleName_001212',
        appIndex: 0
      };
      await badgeManager.setBadgeUpdateTask(notexist_bundleInfo, false);
      expect(badgeManager['mBadgeCache'].size > 1).assertTrue();
      done();
    })

    it('test_getBadgeByBundle_001', 0, async (done: Function) => {
      let bundleInfo: BaseBundleInfo = {
        bundleName: 'testBadgeInfoName_001',
        appIndex: 0
      };
      let mDbStoreManager: RdbStoreManager = badgeManager['mDbStoreManager'];
      if (!mDbStoreManager) {
        mDbStoreManager = RdbStoreManager.getInstance();
      }
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mDbStoreManager, mDbStoreManager.getAllBadge);
      let items: BadgeItemInfo[] = [];
      let item1: BadgeItemInfo = new BadgeItemInfo();
      item1.bundleName = 'badgeName';
      item1.appIndex = 0;
      item1.badgeNumber = 1;
      items.push(item1);
      let item2: BadgeItemInfo = new BadgeItemInfo();
      item2.bundleName = 'badgeName1';
      item2.appIndex = 0;
      item2.badgeNumber = 1;
      items.push(item2);
      when(mockFunc)().afterReturn(items);
      badgeManager.getBadgeByBundle(bundleInfo, (badgeNumber: number) => {
      });
      expect(item1.badgeNumber > 0).assertTrue();
      when(mockFunc)().afterReturn([]);
      expect(item2.badgeNumber > 0).assertTrue();
      mocker.clear(mDbStoreManager);
      mocker.clearAll();
      done();
    })

    it('test_getAppBadgeValue_001', 0, async (done: Function) => {
      let nullInfo = badgeManager.getAppBadgeValue(null);
      expect(nullInfo).assertEqual(0);
      let bundleInfo: BaseBundleInfo = {
        bundleName: 'testBadgeInfoName_001',
        appIndex: 0
      };
      let bundleKey = tempGetCacheKey(bundleInfo);
      badgeManager.setCacheBundleBadge(bundleInfo, 1, false);
      expect(badgeManager['mBadgeCache'].has(bundleKey)).assertTrue();
      let badgeValue = badgeManager.getAppBadgeValue(bundleInfo);
      expect(badgeValue >= 0).assertTrue();
      let bundleInfo1: BaseBundleInfo = {
        bundleName: 'testBName_00109',
        appIndex: 0
      };
      let bundleInfo1Key = tempGetCacheKey(bundleInfo1);
      expect(badgeManager['mBadgeCache'].has(bundleInfo1Key)).assertFalse();
      let badgeValue1 = badgeManager.getAppBadgeValue(bundleInfo1);
      expect(badgeValue1 === 0).assertTrue();
      done();
    })

    it('test_getBadgeByBundleSync_001', 0, async (done: Function) => {
      let mDbStoreManager: RdbStoreManager = badgeManager['mDbStoreManager'];
      if (!mDbStoreManager) {
        mDbStoreManager = RdbStoreManager.getInstance();
      }
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mDbStoreManager, mDbStoreManager.getBadgeByBundle);
      let items: BadgeItemInfo[] = [];
      let item1: BadgeItemInfo = new BadgeItemInfo();
      item1.bundleName = 'badgeName';
      item1.appIndex = 0;
      item1.badgeNumber = 1;
      items.push(item1);
      let item2: BadgeItemInfo = new BadgeItemInfo();
      item2.bundleName = 'badgeName1';
      item2.appIndex = 0;
      item2.badgeNumber = 1;
      items.push(item2);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(items);
      let bundleInfo: BaseBundleInfo = {
        bundleName: 'testBadgeInfoName_001',
        appIndex: 0
      };
      let res = await badgeManager.getBadgeByBundleSync(bundleInfo);
      expect(res === 1).assertTrue();
      when(mockFunc)(ArgumentMatchers.any).afterReturn([]);
      let res1 = await badgeManager.getBadgeByBundleSync(bundleInfo);
      expect(res1 === 0).assertTrue();
      mocker.clear(mDbStoreManager);
      mocker.clearAll();
      done();
    })

    it('test_getBadgeDisplayByBundleSync_001', 0, async (done: Function) => {
      let mDbStoreManager: RdbStoreManager = badgeManager['mDbStoreManager'];
      if (!mDbStoreManager) {
        mDbStoreManager = RdbStoreManager.getInstance();
      }
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mDbStoreManager, mDbStoreManager.getBadgeByBundle);
      let items: BadgeItemInfo[] = [];
      let item1: BadgeItemInfo = new BadgeItemInfo();
      item1.bundleName = 'badgeName';
      item1.appIndex = 0;
      item1.badgeNumber = 1;
      items.push(item1);
      let item2: BadgeItemInfo = new BadgeItemInfo();
      item2.bundleName = 'badgeName1';
      item2.appIndex = 0;
      item2.badgeNumber = 1;
      items.push(item2);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(items);
      let bundleInfo: BaseBundleInfo = {
        bundleName: 'testBadgeInfoName_001',
        appIndex: 0
      };
      let res = await badgeManager.getBadgeByBundleSync(bundleInfo);
      expect(res === 1).assertTrue();
      when(mockFunc)(ArgumentMatchers.any).afterReturn([]);
      let res1 = await badgeManager.getBadgeByBundleSync(bundleInfo);
      expect(res1 === 0).assertTrue();
      mocker.clear(mDbStoreManager);
      mocker.clearAll();
      done();
    })

    it('test_getBadgeDisplayNumberByBundle_isCacheExist_true001', 0, async (done: Function) => {
      const CACHE_LOADED = 2;
      badgeManager['mCacheState'] = CACHE_LOADED;
      let bundleInfo: BaseBundleInfo = {
        bundleName: 'testBadgeInfoName_001',
        appIndex: 0
      };
      let bundleKey = tempGetCacheKey(bundleInfo);
      badgeManager.setCacheBundleBadge(bundleInfo, 1, false);
      let item = badgeManager['mBadgeCache'].get(bundleKey);
      if (item) {
        expect(item).not().assertUndefined();
        item.isShow = true;
        badgeManager['mBadgeCache'].set(bundleKey, item);
        await badgeManager.getBadgeDisplayNumberByBundle(bundleInfo, (badgeNumber: number) => {
        });
        expect(item.isShow).assertTrue();
      }
      done();
    })

    it('test_getBadgeDisplayNumberByBundle_isCacheExist_false001', 0, async (done: Function) => {
      const falseValue = 21;
      badgeManager['mCacheState'] = falseValue;
      let bundleInfo: BaseBundleInfo = {
        bundleName: 'testBadgeInfoName_001233',
        appIndex: 0
      };
      badgeManager.setCacheBundleBadge(bundleInfo, 1, false);
      let mDbStoreManager: RdbStoreManager = badgeManager['mDbStoreManager'];
      if (!mDbStoreManager) {
        mDbStoreManager = RdbStoreManager.getInstance();
      }
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mDbStoreManager, mDbStoreManager.getBadgeByBundle);
      let items: BadgeItemInfo[] = [];
      let item1: BadgeItemInfo = new BadgeItemInfo();
      item1.bundleName = 'badgeName';
      item1.appIndex = 0;
      item1.badgeNumber = 1;
      item1.isShow = false;
      items.push(item1);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(items);
      await badgeManager.getBadgeDisplayNumberByBundle(bundleInfo, (badgeNumber: number) => {
      });
      expect(item1.isShow).assertFalse();
      let item2: BadgeItemInfo = new BadgeItemInfo();
      item2.bundleName = 'badgeName1';
      item2.appIndex = 0;
      item2.badgeNumber = 1;
      item2.isShow = true;
      when(mockFunc)(ArgumentMatchers.any).afterReturn([item2]);
      await badgeManager.getBadgeDisplayNumberByBundle(bundleInfo, (badgeNumber: number) => {
      });
      expect(item2.isShow).assertTrue();
      mocker.clear(mDbStoreManager);
      mocker.clearAll();
      done();
    })


    it('test_getBadgeDisplayNumberByBundleSync_isCacheExist_true001', 0, async (done: Function) => {
      const CACHE_LOADED = 2;
      badgeManager['mCacheState'] = CACHE_LOADED;
      let bundleInfo: BaseBundleInfo = {
        bundleName: 'testBadgeInfoName_001',
        appIndex: 0
      };
      let bundleKey = tempGetCacheKey(bundleInfo);
      badgeManager.setCacheBundleBadge(bundleInfo, 1, false);
      let item = badgeManager['mBadgeCache'].get(bundleKey);
      if (item) {
        expect(item).not().assertUndefined();
        item.isShow = true;
        badgeManager['mBadgeCache'].set(bundleKey, item);
        let res = await badgeManager.getBadgeDisplayNumberByBundleSync(bundleInfo);
        expect(res >= 0).assertTrue();
      }
      done();
    })

    it('test_getBadgeDisplayNumberByBundleSync_isCacheExist_false001', 0, async (done: Function) => {
      const falseValue = 21;
      badgeManager['mCacheState'] = falseValue;
      let bundleInfo: BaseBundleInfo = {
        bundleName: 'testBadgeInfoName_001233',
        appIndex: 0
      };
      badgeManager.setCacheBundleBadge(bundleInfo, 1, false);
      let mDbStoreManager: RdbStoreManager = badgeManager['mDbStoreManager'];
      if (!mDbStoreManager) {
        mDbStoreManager = RdbStoreManager.getInstance();
      }
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mDbStoreManager, mDbStoreManager.getBadgeByBundle);
      let items: BadgeItemInfo[] = [];
      let item1: BadgeItemInfo = new BadgeItemInfo();
      item1.bundleName = 'badgeName';
      item1.appIndex = 0;
      item1.badgeNumber = 1;
      item1.isShow = false;
      items.push(item1);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(items);
      await badgeManager.getBadgeDisplayNumberByBundleSync(bundleInfo);
      expect(item1.isShow).assertFalse();
      let item2: BadgeItemInfo = new BadgeItemInfo();
      item2.bundleName = 'badgeName1';
      item2.appIndex = 0;
      item2.badgeNumber = 1;
      item2.isShow = true;
      when(mockFunc)(ArgumentMatchers.any).afterReturn([item2]);
      await badgeManager.getBadgeDisplayNumberByBundleSync(bundleInfo);
      expect(item2.isShow).assertTrue();
      mocker.clear(mDbStoreManager);
      mocker.clearAll();
      done();
    })

    it('test_refreshDesktopBadge_setThenRefresh_001', 0, async (done: Function) => {
      let bundleInfo: BaseBundleInfo = {
        bundleName: 'bandleName_refresh_003122',
        appIndex: 0
      };
      let bundleKey = tempGetCacheKey(bundleInfo);
      await badgeManager.refreshDesktopBadge(bundleInfo);
      expect(badgeManager['mBadgeCache'].has(bundleKey)).assertFalse();
      badgeManager.setCacheBundleBadge(bundleInfo, 1, false);
      let badgeInfo = badgeManager['mBadgeCache'].get(bundleKey);
      expect(badgeInfo).not().assertUndefined();
      expect(badgeInfo?.isShow === undefined).assertTrue();
      expect(badgeManager['mBadgeCache'].has(bundleKey)).assertTrue();
      let mDbStoreManager: RdbStoreManager = badgeManager['mDbStoreManager'];
      if (!mDbStoreManager) {
        mDbStoreManager = RdbStoreManager.getInstance();
      }
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mDbStoreManager, mDbStoreManager.getBadgeByBundle);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([]);
      await badgeManager.refreshDesktopBadge(bundleInfo);
      let badgeInfo1 = badgeManager['mBadgeCache'].get(bundleKey);
      expect(badgeInfo1?.isShow).assertFalse();
      if (badgeInfo1) {
        badgeInfo1.isShow = true;
        badgeManager['mBadgeCache'].set(bundleKey, badgeInfo1);
        await badgeManager.refreshDesktopBadge(bundleInfo);
        expect(badgeInfo1.isShow).assertTrue();
      }
      mocker.clear(mDbStoreManager);
      mocker.clearAll();
      done();
    })

    it('test_updateBadgeNumber_001', 0, async (done: Function) => {
      let bundleInfo: BaseBundleInfo = {
        bundleName: 'bandleName_refresh_003',
        appIndex: 0
      };
      try {
        let res = await badgeManager.updateBadgeNumber(bundleInfo, -1);
        expect(res).assertFalse();
      } catch (e) {
      }
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let res1 = await badgeManager.updateBadgeNumber(bundleInfo, 2);
        expect(res1).assertTrue();
      } catch (e) {
      }
      try {
        await badgeManager.updateBadgeNumber(bundleInfo, 1);
        expect(CheckEmptyUtils.isEmpty(bundleInfo.bundleName)).assertFalse();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_updateBadgeDisplay_002', 0, async (done: Function) => {
      let bundleInfo: BaseBundleInfo = {
        bundleName: 'bandleName_refresh_003',
        appIndex: 0
      };
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let res = await badgeManager.updateBadgeDisplay(bundleInfo, false);
      expect(res).assertFalse();
      let mDbStoreManager: RdbStoreManager = badgeManager['mDbStoreManager'];
      if (!mDbStoreManager) {
        mDbStoreManager = RdbStoreManager.getInstance();
      }
      let mockFunc1: Function = mocker.mockFunc(mDbStoreManager, mDbStoreManager.updateBadgeDisplayByBundle);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let res1 = await badgeManager.updateBadgeDisplay(bundleInfo, false);
      expect(res1).assertFalse();
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc2: Function = mocker.mockFunc(mDbStoreManager, mDbStoreManager.getBadgeByBundle);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([]);
      let res2 = await badgeManager.updateBadgeDisplay(bundleInfo, false);
      expect(res2).assertTrue();
      let res3 = await badgeManager.updateBadgeDisplay(bundleInfo, true);
      expect(res3).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clear(mDbStoreManager);
      mocker.clearAll();
      done();
    })

    it('test_getBadgeOffsetX_002', 0, async (done: Function) => {
      expect(badgeManager.getBadgeOffsetX(StyleConstants.DEFAULT_0, 0, 0)).assertEqual(0);
      let badgeNum010 = badgeManager.getBadgeOffsetX(StyleConstants.DEFAULT_5, 0, 50);
      let expectRes = 50 + StyleConstants.PC_BADGE_OFFSET_X_EXTENSION - StyleConstants.PC_BADGE_SIZE;
      expect(badgeNum010).assertEqual(expectRes);
      let badgeNum = StyleConstants.DEFAULT_20;
      let fontSizeNum = 14;
      let iconSize = 150;
      let badgeNum20 = badgeManager.getBadgeOffsetX(badgeNum, fontSizeNum, iconSize);
      expect(badgeNum20 < iconSize + StyleConstants.PC_BADGE_OFFSET_X_EXTENSION).assertTrue();
      let badgeNumMax = StyleConstants.MAX_BADGE_COUNT + 20;
      let badgeNum_max = badgeManager.getBadgeOffsetX(badgeNumMax, fontSizeNum, iconSize);
      expect(badgeNum_max < iconSize + StyleConstants.PC_BADGE_OFFSET_X_EXTENSION).assertTrue();
      done();
    })

    it('test_getBadgePostion_asset001', 0, async (done: Function) => {
      let position = badgeManager.getBadgePostion(StyleConstants.DEFAULT_0, 0, 0);
      expect(position.y).assertEqual(StyleConstants.PC_BADGE_OFFSET_Y);
      done();
    })
  })
}

function tempGetCacheKey(bundleInfo: BaseBundleInfo): string {
  return `${bundleInfo.bundleName}${bundleInfo.appIndex ?? 0}`;
}