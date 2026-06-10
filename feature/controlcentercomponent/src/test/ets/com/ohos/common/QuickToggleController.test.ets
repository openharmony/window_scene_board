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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import { QuickToggleController } from '../../../../../main/ets/com/ohos/controller/QuickToggleController';
import { ToggleData } from '../../../../../main/ets/com/ohos/common/Constants';

export function QuickToggleControllerTest() {
  describe('QuickToggleControllerTest', (): void => {

    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    let sQuickToggleController = QuickToggleController.getInstance();
    it('QuickToggleControllerTest001', 0, (): void => {
      let getQuickToggleColumn: number = sQuickToggleController.getQuickToggleColumn();
      expect(getQuickToggleColumn).assertEqual(5);
      let getLottieDataDownResource:object | undefined= sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource :object | undefined= sQuickToggleController.getLottieDataUpResource(true);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let template = '1fr';
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(1);
      expect(getToggleGridTemplate).assertEqual(template);
    })

    it('QuickToggleControllerTest002', 0, (): void => {
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(1);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let getToggleColumn: number = sQuickToggleController.getToggleColumn();
      expect(getToggleColumn).assertInstanceOf('Number');
      let getLottieDataDownResource :object | undefined= sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(true);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
    })

    it('QuickToggleControllerTest003', 0, (): void => {
      let getQuickToggleColumn: number = sQuickToggleController.getQuickToggleColumn();
      expect(getQuickToggleColumn).assertEqual(5);
      let getToggleColumn: number = sQuickToggleController.getToggleColumn();
      expect(getToggleColumn).assertInstanceOf('Number');
      let template = '1fr';
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(1);
      expect(getToggleGridTemplate).assertEqual(template);
    })

    it('QuickToggleControllerTest004', 0, (): void => {
      let getQuickToggleColumn: number = sQuickToggleController.getQuickToggleColumn();
      expect(getQuickToggleColumn).assertEqual(5);
      let template = '1fr';
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(1);
      expect(getToggleGridTemplate).assertEqual(template);
      let getLottieDataDownResource :object | undefined= sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined= sQuickToggleController.getLottieDataUpResource(true);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
    })

    it('QuickToggleControllerTest005', 0, (): void => {
      let getQuickToggleColumn: number = sQuickToggleController.getQuickToggleColumn();
      expect(getQuickToggleColumn).assertInstanceOf('Number');
      let getToggleColumn: number = sQuickToggleController.getToggleColumn();
      expect(getToggleColumn).assertInstanceOf('Number');
    })

    it('QuickToggleControllerTest006', 0, (): void => {
      let getLottieDataDownResource :object | undefined= sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource = sQuickToggleController.getLottieDataUpResource(true)
      expect(getLottieDataUpResource !== null).assertEqual(true);
      let toggleDataUri: string = sQuickToggleController.toggleDataUri
      expect(toggleDataUri).assertInstanceOf('String');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(4)
      expect(getToggleGridTemplate).assertInstanceOf('String');
    })

    it('QuickToggleControllerTest007', 0, (): void => {
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(true)
      expect(getLottieDataUpResource !== null).assertEqual(true);
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let toggleDataUri: string = sQuickToggleController.toggleDataUri
      expect(toggleDataUri).assertInstanceOf('String');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(1)
      expect(getToggleGridTemplate).assertInstanceOf('String');
    })

    it('QuickToggleControllerTest008', 0, (): void => {
      let getQuickToggleColumn: number = sQuickToggleController.getQuickToggleColumn();
      expect(getQuickToggleColumn > 0).assertEqual(true);
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(true);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(8);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let getQuickToggleStr: string[] = sQuickToggleController.getQuickToggleStr()
      expect(getQuickToggleStr !== null).assertEqual(true);
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let getToggleData: ToggleData = sQuickToggleController.getToggleData()
      expect(getToggleData !== null).assertEqual(true);
      let getDefaultQuickToggleData: string[] = sQuickToggleController.getDefaultQuickToggleData()
      expect(getDefaultQuickToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('8')
      expect(createToggleController !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest009', 0, (): void => {
      let getQuickToggleColumn: number = sQuickToggleController.getQuickToggleColumn();
      expect(getQuickToggleColumn > 0).assertEqual(true);
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(true);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(9);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let getQuickToggleStr: string[] = sQuickToggleController.getQuickToggleStr()
      expect(getQuickToggleStr !== null).assertEqual(true);
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let getToggleData: ToggleData = sQuickToggleController.getToggleData()
      expect(getToggleData !== null).assertEqual(true);
      let getDefaultQuickToggleData: string[] = sQuickToggleController.getDefaultQuickToggleData()
      expect(getDefaultQuickToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('9')
      expect(createToggleController !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0010', 0, (): void => {
      let getQuickToggleColumn: number = sQuickToggleController.getQuickToggleColumn();
      expect(getQuickToggleColumn > 0).assertEqual(true);
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined= sQuickToggleController.getLottieDataUpResource(true);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let template = '1fr';
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(10);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let getQuickToggleStr: string[] = sQuickToggleController.getQuickToggleStr()
      expect(getQuickToggleStr !== null).assertEqual(true);
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(true)
      expect(refreshToggleData !== null).assertEqual(true);
      let getToggleData: ToggleData = sQuickToggleController.getToggleData()
      expect(getToggleData !== null).assertEqual(true);
      let getDefaultQuickToggleData: string[] = sQuickToggleController.getDefaultQuickToggleData()
      expect(getDefaultQuickToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('10')
      expect(createToggleController !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0020', 0, (): void => {
      let getQuickToggleColumn: number = sQuickToggleController.getQuickToggleColumn();
      expect(getQuickToggleColumn > 0).assertEqual(true);
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(true);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let template = '1fr';
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(20);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let getQuickToggleStr: string[] = sQuickToggleController.getQuickToggleStr()
      expect(getQuickToggleStr !== null).assertEqual(true);
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let getToggleData: ToggleData = sQuickToggleController.getToggleData()
      expect(getToggleData !== null).assertEqual(true);
      let getDefaultQuickToggleData: string[] = sQuickToggleController.getDefaultQuickToggleData()
      expect(getDefaultQuickToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('20')
      expect(createToggleController !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0011', 0, (): void => {
      let getQuickToggleColumn: number = sQuickToggleController.getQuickToggleColumn();
      expect(getQuickToggleColumn > 0).assertEqual(true);
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(true);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let template = '1fr';
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(11);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let getQuickToggleStr: string[] = sQuickToggleController.getQuickToggleStr()
      expect(getQuickToggleStr !== null).assertEqual(true);
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let getToggleData: ToggleData = sQuickToggleController.getToggleData()
      expect(getToggleData !== null).assertEqual(true);
      let getDefaultQuickToggleData: string[] = sQuickToggleController.getDefaultQuickToggleData()
      expect(getDefaultQuickToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('11')
      expect(createToggleController !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0012', 0, (): void => {
      let getQuickToggleColumn: number = sQuickToggleController.getQuickToggleColumn();
      expect(getQuickToggleColumn > 0).assertEqual(true);
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(true);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let template = '1fr';
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(12);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let getQuickToggleStr: string[] = sQuickToggleController.getQuickToggleStr()
      expect(getQuickToggleStr !== null).assertEqual(true);
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(true)
      expect(refreshToggleData !== null).assertEqual(true);
      let getToggleData: ToggleData = sQuickToggleController.getToggleData()
      expect(getToggleData !== null).assertEqual(true);
      let getDefaultQuickToggleData: string[] = sQuickToggleController.getDefaultQuickToggleData()
      expect(getDefaultQuickToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('12')
      expect(createToggleController !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0013', 0, (): void => {
      let getQuickToggleColumn: number = sQuickToggleController.getQuickToggleColumn();
      expect(getQuickToggleColumn > 0).assertEqual(true);
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let template = '1fr';
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(13);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let getQuickToggleStr: string[] = sQuickToggleController.getQuickToggleStr()
      expect(getQuickToggleStr !== null).assertEqual(true);
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let getToggleData: ToggleData = sQuickToggleController.getToggleData()
      expect(getToggleData !== null).assertEqual(true);
      let getDefaultQuickToggleData: string[] = sQuickToggleController.getDefaultQuickToggleData()
      expect(getDefaultQuickToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('13')
      expect(createToggleController !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0014', 0, (): void => {
      let getQuickToggleColumn: number = sQuickToggleController.getQuickToggleColumn();
      expect(getQuickToggleColumn > 0).assertEqual(true);
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(true);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let template = '1fr';
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(14);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let getQuickToggleStr: string[] = sQuickToggleController.getQuickToggleStr()
      expect(getQuickToggleStr !== null).assertEqual(true);
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(true)
      expect(refreshToggleData !== null).assertEqual(true);
      let getToggleData: ToggleData = sQuickToggleController.getToggleData()
      expect(getToggleData !== null).assertEqual(true);
      let getDefaultQuickToggleData: string[] = sQuickToggleController.getDefaultQuickToggleData()
      expect(getDefaultQuickToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('14')
      expect(createToggleController !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0015', 0, (): void => {
      let getQuickToggleColumn: number = sQuickToggleController.getQuickToggleColumn();
      expect(getQuickToggleColumn > 0).assertEqual(true);
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource :object | undefined = sQuickToggleController.getLottieDataUpResource(true);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let template = '1fr';
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(15);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let getQuickToggleStr: string[] = sQuickToggleController.getQuickToggleStr()
      expect(getQuickToggleStr !== null).assertEqual(true);
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let getToggleData: ToggleData = sQuickToggleController.getToggleData()
      expect(getToggleData !== null).assertEqual(true);
      let getDefaultQuickToggleData: string[] = sQuickToggleController.getDefaultQuickToggleData()
      expect(getDefaultQuickToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('15')
      expect(createToggleController !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0016', 0, (): void => {
      let getQuickToggleColumn: number = sQuickToggleController.getQuickToggleColumn();
      expect(getQuickToggleColumn > 0).assertEqual(true);
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(true);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let template = '1fr';
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(16);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let getQuickToggleStr: string[] = sQuickToggleController.getQuickToggleStr()
      expect(getQuickToggleStr !== null).assertEqual(true);
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(true)
      expect(refreshToggleData !== null).assertEqual(true);
      let getToggleData: ToggleData = sQuickToggleController.getToggleData()
      expect(getToggleData !== null).assertEqual(true);
      let getDefaultQuickToggleData: string[] = sQuickToggleController.getDefaultQuickToggleData()
      expect(getDefaultQuickToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('16')
      expect(createToggleController !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0017', 0, (): void => {
      let getQuickToggleColumn: number = sQuickToggleController.getQuickToggleColumn();
      expect(getQuickToggleColumn > 0).assertEqual(true);
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(true);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let template = '1fr';
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(17);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let getQuickToggleStr: string[] = sQuickToggleController.getQuickToggleStr()
      expect(getQuickToggleStr !== null).assertEqual(true);
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let getToggleData: ToggleData = sQuickToggleController.getToggleData()
      expect(getToggleData !== null).assertEqual(true);
      let getDefaultQuickToggleData: string[] = sQuickToggleController.getDefaultQuickToggleData()
      expect(getDefaultQuickToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('17')
      expect(createToggleController !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0018', 0, (): void => {
      let getQuickToggleColumn: number = sQuickToggleController.getQuickToggleColumn();
      expect(getQuickToggleColumn > 0).assertEqual(true);
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let template = '1fr';
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(18);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let getQuickToggleStr: string[] = sQuickToggleController.getQuickToggleStr()
      expect(getQuickToggleStr !== null).assertEqual(true);
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(true)
      expect(refreshToggleData !== null).assertEqual(true);
      let getToggleData: ToggleData = sQuickToggleController.getToggleData()
      expect(getToggleData !== null).assertEqual(true);
      let getDefaultQuickToggleData: string[] = sQuickToggleController.getDefaultQuickToggleData()
      expect(getDefaultQuickToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('17')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(123)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0019', 0, (): void => {
      let getQuickToggleColumn: number = sQuickToggleController.getQuickToggleColumn();
      expect(getQuickToggleColumn > 0).assertEqual(true);
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let template = '1fr';
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(19);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let getQuickToggleStr: string[] = sQuickToggleController.getQuickToggleStr()
      expect(getQuickToggleStr !== null).assertEqual(true);
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(true)
      expect(refreshToggleData !== null).assertEqual(true);
      let getToggleData: ToggleData = sQuickToggleController.getToggleData()
      expect(getToggleData !== null).assertEqual(true);
      let getDefaultQuickToggleData: string[] = sQuickToggleController.getDefaultQuickToggleData()
      expect(getDefaultQuickToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('19')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged: void = sQuickToggleController.onUserChanged(1234)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0021', 0, (): void => {
      let getQuickToggleColumn: number = sQuickToggleController.getQuickToggleColumn();
      expect(getQuickToggleColumn > 0).assertEqual(true);
      let getLottieDataDownResource :object | undefined= sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource :object | undefined= sQuickToggleController.getLottieDataUpResource(true);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(21);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let getQuickToggleStr: string[] = sQuickToggleController.getQuickToggleStr()
      expect(getQuickToggleStr !== null).assertEqual(true);
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(true)
      expect(refreshToggleData !== null).assertEqual(true);
      let getToggleData: ToggleData = sQuickToggleController.getToggleData()
      expect(getToggleData !== null).assertEqual(true);
      let getDefaultQuickToggleData: string[] = sQuickToggleController.getDefaultQuickToggleData()
      expect(getDefaultQuickToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('21')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged: void = sQuickToggleController.onUserChanged(12345)
      expect(onUserChanged !== null).assertEqual(true);
      let toggleData  = sQuickToggleController.toggleData
      expect(toggleData !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0022', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(22);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(true)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('22')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(1236)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0023', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(23);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(true)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('23')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(11)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0024', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(24);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('24')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(24)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0025', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(25);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(true)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('25')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(25)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0026', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(26);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('26')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(26)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0027', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(27);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(true)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('27')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(27)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0028', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(28);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(true)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('28')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(28)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0029', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(29);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('29')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(29)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0030', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(30);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('30')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(30)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0031', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(31);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(true)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('31')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(31)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0032', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(32);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(true)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('32')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(32)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0033', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(33);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(true)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('33')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(33)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0034', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(34);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('34')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(34)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0035', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(35);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('35')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(35)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0036', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(36);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('36')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(36)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0037', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(37);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('37')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(37)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0038', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(38);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('38')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(38)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0039', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(39);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('39')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(39)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0040', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(40);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('40')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(40)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0041', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(41);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('41')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(41)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0042', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(42);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('42')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(42)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0043', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(43);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('43')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(43)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0044', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(44);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('44')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(44)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0045', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(45);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('45')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(45)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0046', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(46);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('46')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(46)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0047', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(47);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('47')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(47)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0048', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(48);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('48')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(48)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0049', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(49);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('49')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(49)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0050', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(50);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('50')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(50)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0051', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(51);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('51')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(51)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0052', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(52);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(false)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('52')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(52)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0053', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(true);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(53);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(true)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('53')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(53)
      expect(onUserChanged !== null).assertEqual(true);
    })

    it('QuickToggleControllerTest0054', 0, (): void => {
      let getLottieDataDownResource:object | undefined = sQuickToggleController.getLottieDataDownResource(false);
      expect(getLottieDataDownResource).assertInstanceOf('Object');
      let getLottieDataUpResource:object | undefined = sQuickToggleController.getLottieDataUpResource(false);
      expect(getLottieDataUpResource).assertInstanceOf('Object');
      let getToggleGridTemplate: string = sQuickToggleController.getToggleGridTemplate(54);
      expect(getToggleGridTemplate).assertInstanceOf('String');
      let refreshToggleData: Promise<ToggleData> = sQuickToggleController.refreshToggleData(true)
      expect(refreshToggleData !== null).assertEqual(true);
      let createToggleController = sQuickToggleController.createToggleController('54')
      expect(createToggleController !== null).assertEqual(true);
      let onUserChanged = sQuickToggleController.onUserChanged(54)
      expect(onUserChanged !== null).assertEqual(true);
    })
  })
}