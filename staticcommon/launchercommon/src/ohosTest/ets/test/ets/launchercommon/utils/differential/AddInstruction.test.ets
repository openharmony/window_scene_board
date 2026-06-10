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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { AddInstruction, CommonConstants, PageDesktopModel } from '../../../../../../../main/ets/TsIndex';
import { GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex';


export default function AddInstructionTest() {
  describe('AddInstructionTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('AddInstructionTest_execute', 0, (): void => {
      let gridLayoutInfo: GridLayoutItemInfo[] = [];
      let addExe: AddInstruction = new AddInstruction(6, 4);
      let newLayout: GridLayoutItemInfo[] = addExe.execute(gridLayoutInfo, null);
      expect(newLayout.length).assertEqual(0);

      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.photos';
      item.abilityName = 'com.ohos.contacts.MainAbility';
      item.bundleName = 'com.ohos.photos2';
      item.moduleName = 'entry';
      item.container = -100;
      item.typeId = 0;
      gridLayoutInfo.push(item);
      newLayout = addExe.execute(gridLayoutInfo, item);
      expect(newLayout.length).assertEqual(1);
    })

    it('AddInstructionTest_realize', 0, (): void => {
      let addInstruction: AddInstruction = new AddInstruction(6, 4);
      expect(addInstruction['realize'](null, null)).assertNull();

      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.photos';
      item.abilityName = 'com.ohos.contacts.MainAbility';
      item.bundleName = 'com.ohos.photos2';
      item.moduleName = 'entry';
      item.container = -100;
      item.typeId = 0;
      let gridLayoutInfo: GridLayoutItemInfo[] = [];
      gridLayoutInfo.push(item);

      expect(addInstruction['realize'](gridLayoutInfo, null)).not().assertNull();
      expect(addInstruction['realize'](gridLayoutInfo, item)).not().assertNull();
    })

    it('AddInstructionTest_dealAddAppInDock', 0, (): void => {
      let addInstruction: AddInstruction = new AddInstruction(6, 4);
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.photos';
      item.abilityName = 'com.ohos.contacts.MainAbility';
      item.bundleName = 'com.ohos.photos2';
      item.moduleName = 'entry';
      item.container = -100;
      item.typeId = 0;
      item.page = 2;
      item.row = 2;
      item.column = 2;
      item.area = [3, 4];
      let gridLayoutInfo: GridLayoutItemInfo[] = [];
      gridLayoutInfo.push(item);
      expect(addInstruction['dealAddAppInDock'](gridLayoutInfo, item)).not().assertNull();
      expect(addInstruction['dealAddAppInDesktop'](gridLayoutInfo, item)).not().assertNull();
    })

    it("realize1", 0, async(done:Function) => {
      let addInstruction: AddInstruction = new AddInstruction(6, 4);
      let gridInfo= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_SMARTDOCK,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: 1
      }) as GridLayoutItemInfo;
      let item = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_SMARTDOCK,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: 1
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(addInstruction, addInstruction['isOnePlusOneItem']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(addInstruction, addInstruction['isItemExist']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function =
        mocker.mockFunc(addInstruction, addInstruction['dealAddAppInDock']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn([gridInfo]);
      let result:GridLayoutItemInfo[] = addInstruction['realize']([gridInfo],item);
      expect(result[0]!.page).assertEqual(1);
      mocker.clear(addInstruction);
      mocker.clearAll();
      done();
    })

    it("realize2", 0, async(done:Function) => {
      let addInstruction: AddInstruction = new AddInstruction(6, 4);
      let gridInfo= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CLOCK_BUNDLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: 1
      }) as GridLayoutItemInfo;
      let item = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CLOCK_BUNDLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: 1
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(addInstruction, addInstruction['isOnePlusOneItem']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(addInstruction, addInstruction['isItemExist']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction2: Function =
        mocker.mockFunc(addInstruction, addInstruction['dealAddAppInDesktop']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn([gridInfo]);
      let result:GridLayoutItemInfo[] = addInstruction['realize']([gridInfo],item);
      expect(result[0]!.page).assertEqual(1);
      mocker.clear(addInstruction);
      mocker.clearAll();
      done();
    })

    it("dealAddAppInDock", 0, async(done:Function) => {
      let addInstruction: AddInstruction = new AddInstruction(6, 4);
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.photos';
      item.abilityName = 'com.ohos.contacts.MainAbility';
      item.bundleName = 'com.ohos.photos2';
      item.moduleName = 'entry';
      item.container = -101;
      item.typeId = 0;
      item.page = 2;
      item.row = 2;
      item.column = 2;
      item.area = [3, 4];
      let gridLayoutInfo: GridLayoutItemInfo[] = [item,item,item,item,item];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(PageDesktopModel.getInstance(), PageDesktopModel.getInstance().getGridOccupyStatusEnum);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([['U','F','0']]);
      expect(addInstruction['dealAddAppInDock'](gridLayoutInfo, item)).not().assertNull();
      expect(addInstruction['dealAddAppInDesktop'](gridLayoutInfo, item)).not().assertNull();
      mocker.clear(PageDesktopModel.getInstance());
      mocker.clearAll();
      done();
    })

    it("dealAddAppInDesktop1", 0, async(done:Function) => {
      let addInstruction: AddInstruction = new AddInstruction(6, 4);
      let gridInfo= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CLOCK_BUNDLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: 1
      }) as GridLayoutItemInfo;
      let gridInfo1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_SMARTDOCK,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: 1
      }) as GridLayoutItemInfo;
      let item = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CLOCK_BUNDLE,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: 1
      }) as GridLayoutItemInfo;
      let gridInfoList: GridLayoutItemInfo[] = [gridInfo,gridInfo1,gridInfo,gridInfo1];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(PageDesktopModel.getInstance(), PageDesktopModel.getInstance().getGridOccupyStatusEnum);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([['U','F','0']]);
      let result = addInstruction['dealAddAppInDesktop'](gridInfoList,item);
      expect(result.length>4).assertTrue();
      mocker.clear(PageDesktopModel.getInstance());
      mocker.clearAll();
      done();
    })

    it("dealAddAppInDesktop2", 0, async(done:Function) => {
      let addInstruction: AddInstruction = new AddInstruction(6, 4);
      let gridInfo= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CLOCK_BUNDLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: 1
      }) as GridLayoutItemInfo;
      let gridInfo1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_SMARTDOCK,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: 1
      }) as GridLayoutItemInfo;
      let item = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CLOCK_BUNDLE,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: 1
      }) as GridLayoutItemInfo;
      let gridInfoList: GridLayoutItemInfo[] = [gridInfo,gridInfo1,gridInfo,gridInfo1];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(PageDesktopModel.getInstance(), PageDesktopModel.getInstance().getGridOccupyStatusEnum);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([['O','F','U']]);
      let result = addInstruction['dealAddAppInDesktop'](gridInfoList,item);
      expect(result.length>4).assertTrue();
      mocker.clear(PageDesktopModel.getInstance());
      mocker.clearAll();
      done();
    })
  })
}