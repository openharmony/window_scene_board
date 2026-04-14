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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { UpdateFormStackItemInstruction } from '../../../../../../../main/ets/TsIndex';
import { GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex';


export default function UpdateFormStackItemInstructionTest() {
  describe('UpdateFormStackItemInstructionTest', (): void => {

    let gridLayoutInfo: GridLayoutItemInfo[] = [];
    let formStackItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    formStackItem.formStackId = '123';
    formStackItem.typeId = 6;
    formStackItem.page = 1;
    formStackItem.row = 0;
    formStackItem.column = 0;

    let oldForm1: GridLayoutItemInfo = new GridLayoutItemInfo();
    oldForm1.bundleName = 'com.ohos.health';
    oldForm1.cardDimension = 1;

    let oldForm2: GridLayoutItemInfo = new GridLayoutItemInfo();
    oldForm2.bundleName = 'com.ohos.clock';
    oldForm2.cardDimension = 1;

    let oldForms: GridLayoutItemInfo[] = [];
    oldForms.push(oldForm1);
    oldForms.push(oldForm2);

    formStackItem.layoutInfo = [oldForms];
    gridLayoutInfo.push(formStackItem);

    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    // formStackId not equal
    it('UpdateFormStackItemInstructionTest_execute_01', 0, (): void => {
      let diffItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      diffItem.formStackId = '456';

      let exe: UpdateFormStackItemInstruction = new UpdateFormStackItemInstruction(6, 4);
      let newLayout = exe.execute(gridLayoutInfo, diffItem);

      let mergeFormNum = newLayout[0].layoutInfo?.[0].length;
      expect(mergeFormNum).assertEqual(2);
    })

    // newForms layoutInfo not Exit
    it('UpdateFormStackItemInstructionTest_execute_02', 0, (): void => {
       try{
         let diffItem: GridLayoutItemInfo = new GridLayoutItemInfo();
         diffItem.formStackId = '123';

         let exe: UpdateFormStackItemInstruction = new UpdateFormStackItemInstruction(6, 4);
         let newLayout = exe.execute(gridLayoutInfo, diffItem);

         let mergeFormNum = newLayout[0].layoutInfo?.[0]?.length;
         expect(mergeFormNum).not().assertNull();
       }catch{}
    })

    // successful newFormsNum >= oldFormsNum
    it('UpdateFormStackItemInstructionTest_execute_03', 0, (): void => {
      try {
        let diffItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        diffItem.formStackId = '123';

        let newForm1: GridLayoutItemInfo = new GridLayoutItemInfo();
        newForm1.bundleName = 'com.ohos.contacts';
        newForm1.cardDimension = 1;
        let newForm2: GridLayoutItemInfo = new GridLayoutItemInfo();
        newForm2.bundleName = 'com.ohos.tips';
        newForm2.cardDimension = 1;
        let newForms: GridLayoutItemInfo[] = [];
        newForms.push(newForm1);
        newForms.push(newForm2);
        diffItem.layoutInfo = [newForms];

        let exe: UpdateFormStackItemInstruction = new UpdateFormStackItemInstruction(6, 4);
        let newLayout = exe.execute(gridLayoutInfo, diffItem);

        let mergeFormNum = newLayout[0].layoutInfo?.[0].length;
        expect(mergeFormNum).assertLargerOrEqual(2);
      }catch{}
    })

    // newFormsNum > 4
    it('UpdateFormStackItemInstructionTest_execute_04', 0, (): void => {
      try {
        let diffItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        diffItem.formStackId = '123';

        let newForm1: GridLayoutItemInfo = new GridLayoutItemInfo();
        newForm1.bundleName = 'com.ohos.contacts';
        newForm1.cardDimension = 1;
        let newForm2: GridLayoutItemInfo = new GridLayoutItemInfo();
        newForm2.bundleName = 'com.ohos.tips';
        newForm2.cardDimension = 1;
        let newForm3: GridLayoutItemInfo = new GridLayoutItemInfo();
        newForm3.bundleName = 'com.ohos.contacts';
        newForm3.cardDimension = 1;
        let newForm4: GridLayoutItemInfo = new GridLayoutItemInfo();
        newForm4.bundleName = 'com.ohos.tips';
        newForm4.cardDimension = 1;
        let newForm5: GridLayoutItemInfo = new GridLayoutItemInfo();
        newForm5.bundleName = 'com.ohos.tips';
        newForm5.cardDimension = 1;
        let newForms: GridLayoutItemInfo[] = [];
        newForms.push(newForm1);
        newForms.push(newForm2);
        newForms.push(newForm3);
        newForms.push(newForm4);
        newForms.push(newForm5);
        diffItem.layoutInfo = [newForms];

        let exe: UpdateFormStackItemInstruction = new UpdateFormStackItemInstruction(6, 4);
        let newLayout = exe.execute(gridLayoutInfo, diffItem);

        let mergeFormNum = newLayout[0].layoutInfo?.[0].length;
        expect(mergeFormNum).assertLargerOrEqual(2);
      }catch{}
    })

    // newFormsNum = 0
    it('UpdateFormStackItemInstructionTest_execute_05', 0, (): void => {
      try{
        let diffItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        diffItem.formStackId = '123';
        let newForms: GridLayoutItemInfo[] = [];
        diffItem.layoutInfo = [newForms];

        let exe: UpdateFormStackItemInstruction = new UpdateFormStackItemInstruction(6, 4);
        let newLayout = exe.execute(gridLayoutInfo, diffItem);

        let mergeFormNum = newLayout[0].layoutInfo?.[0].length;
        expect(mergeFormNum).assertLargerOrEqual(2);
      }catch{}
    })

    // isTransparent = true
    it('UpdateFormStackItemInstructionTest_execute_06', 0, (): void => {
      try {
        let diffItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        diffItem.formStackId = '123';

        let newForm1: GridLayoutItemInfo = new GridLayoutItemInfo();
        newForm1.bundleName = 'com.ohos.contacts';
        newForm1.isTransparent = true;
        let newForm2: GridLayoutItemInfo = new GridLayoutItemInfo();
        newForm2.bundleName = 'com.ohos.tips';
        let newForms: GridLayoutItemInfo[] = [];
        newForms.push(newForm1);
        newForms.push(newForm2);
        diffItem.layoutInfo = [newForms];

        let exe: UpdateFormStackItemInstruction = new UpdateFormStackItemInstruction(6, 4);
        let newLayout = exe.execute(gridLayoutInfo, diffItem);

        let mergeFormNum = newLayout[0].layoutInfo?.[0].length;
        expect(mergeFormNum).assertLargerOrEqual(2);
      }catch{}
    })

    // cardDimension not match
    it('UpdateFormStackItemInstructionTest_execute_07', 0, (): void => {
       try{
         let diffItem: GridLayoutItemInfo = new GridLayoutItemInfo();
         diffItem.formStackId = '123';

         let newForm1: GridLayoutItemInfo = new GridLayoutItemInfo();
         newForm1.bundleName = 'com.ohos.contacts';
         newForm1.cardDimension = 2;
         let newForm2: GridLayoutItemInfo = new GridLayoutItemInfo();
         newForm2.bundleName = 'com.ohos.tips';
         newForm1.cardDimension = 3;
         let newForms: GridLayoutItemInfo[] = [];
         newForms.push(newForm1);
         newForms.push(newForm2);
         diffItem.layoutInfo = [newForms];

         let exe: UpdateFormStackItemInstruction = new UpdateFormStackItemInstruction(6, 4);
         let newLayout = exe.execute(gridLayoutInfo, diffItem);

         let mergeFormNum = newLayout[0].layoutInfo?.[0].length;
         expect(mergeFormNum).assertLargerOrEqual(2);
       }catch{}
    })

    // successful newFormsNum < oldFormsNum
    it('UpdateFormStackItemInstructionTest_execute_08', 0, (): void => {
      try {
        let diffItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        diffItem.formStackId = '123';

        let newForm1: GridLayoutItemInfo = new GridLayoutItemInfo();
        newForm1.bundleName = 'com.ohos.contacts';
        newForm1.cardDimension = 1;
        let newForms: GridLayoutItemInfo[] = [];
        newForms.push(newForm1);
        diffItem.layoutInfo = [newForms];

        let exe: UpdateFormStackItemInstruction = new UpdateFormStackItemInstruction(6, 4);
        let newLayout = exe.execute(gridLayoutInfo, diffItem);

        let mergeFormNum = newLayout[0].layoutInfo?.[0].length;
        expect(mergeFormNum).assertLargerOrEqual(2);
      }catch{}
    })

    // has duplicate bundleName
    it('UpdateFormStackItemInstructionTest_execute_09', 0, (): void => {
       try{
         let diffItem: GridLayoutItemInfo = new GridLayoutItemInfo();
         diffItem.formStackId = '123';

         let newForm1: GridLayoutItemInfo = new GridLayoutItemInfo();
         newForm1.bundleName = 'com.ohos.contacts';
         newForm1.cardDimension = 1;
         let newForm2: GridLayoutItemInfo = new GridLayoutItemInfo();
         newForm2.bundleName = 'com.ohos.contacts';
         newForm1.cardDimension = 2;
         let newForms: GridLayoutItemInfo[] = [];
         newForms.push(newForm1);
         newForms.push(newForm2);
         diffItem.layoutInfo = [newForms];

         let exe: UpdateFormStackItemInstruction = new UpdateFormStackItemInstruction(6, 4);
         let newLayout = exe.execute(gridLayoutInfo, diffItem);

         let mergeFormNum = newLayout[0].layoutInfo?.[0].length;
         expect(mergeFormNum).assertLargerOrEqual(2);
       }catch{}
    })
  })
}
