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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import { QuickToggleController } from '../../../../../main/ets/com/ohos/controller/QuickToggleController';
import { ToggleData } from '../../../../../main/ets/com/ohos/common/Constants';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, Level, ArgumentMatchers, it, MockKit, when
} from '@ohos/hypium';
import { Component, Driver, On, ON, Point } from '@ohos.UiTest';
import { abilityDelegator, run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';
import { FormController } from '@ohos/dataprovider/src/main/ets/controller/FormController'
import { FormControllerManager } from "@ohos/dataprovider/src/main/ets/controller/FormControllerManager"
import { Task, TaskUri } from "@ohos/dataprovider/src/main/ets/database/databaseconstant/TaskInfo"
import { UserFileManagerAccess } from "@ohos/common/src/main/ets/default/access/UserFileManagerAccess"
import DatabaseProxy from "@ohos/dataprovider/src/main/ets/database/DatabaseProxy"
import { taskpool } from "@kit.ArkTS"
import { AlbumType } from "@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil"
import { AlbumInfo } from "@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo"
import { FaCardAlbumUtils } from "@ohos/dataprovider/src/main/ets/database/service/FaCardAlbumService"
import ReminderService from "@ohos/dataprovider/src/main/ets/database/service/ReminderService"
import FaCardService, { FaCardInfo } from "@ohos/dataprovider/src/main/ets/database/service/FaCardService"
import { AlbumType as FATableAlbumType } from '@ohos/dataprovider/src/main/ets/database/databaseconstant/FaCardTable'
import { DataShareResultSet } from "@kit.ArkData"
import ImageProxyDataService from "@ohos/dataprovider/src/main/ets/database/service/ImageProxyDataService"
import { photoAccessHelper } from "@kit.MediaLibraryKit"

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
  })
  describe('IMediaAPPGalleryVideodeletion001Test', (): void => {
    let controller: FormController;
    let mocker: MockKit
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllIMediaAPPGalleryVideodeletion001').init();
      dt.log.i('beforeAll IMediaAPPGalleryVideodeletion001 start');
      dt.log.i('beforeAll IMediaAPPGalleryVideodeletion001 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    run('IMediaAPPGalleryVideodeletion001', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await iMediaAPPGalleryVideodeletion001(dt);
    });

    run('IMediaAPPGalleryVideodeletion002', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await iMediaAPPGalleryVideodeletion002(dt);
    });

    run('IMediaAPPGalleryVideodeletion003', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await iMediaAPPGalleryVideodeletion003(dt);
    });

    run('IMediaAPPGalleryVideodeletion004', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await iMediaAPPGalleryVideodeletion004(dt);
    });

    run('IMediaAPPGalleryVideodeletion005', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await iMediaAPPGalleryVideodeletion005(dt);
    });

    run('IMediaAPPGalleryVideodeletion006', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await iMediaAPPGalleryVideodeletion006(dt);
    });

    run('IMediaAPPGalleryVideodeletion007', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await iMediaAPPGalleryVideodeletion007(dt);
    });

    run('IMediaAPPGalleryVideodeletion008', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await iMediaAPPGalleryVideodeletion008(dt);
    });

    run('IMediaAPPGalleryVideodeletion009', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await iMediaAPPGalleryVideodeletion009(dt);
    });

    run('MultimediaGalleryAlbumsClone0001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsClone0001(dt);
    });

    run('MultimediaGalleryAlbumsClone0002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsClone0002(dt);
    });

    run('MultimediaGalleryAlbumsClone0003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsClone0003(dt);
    });

    run('MultimediaGalleryAlbumsLayout0001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsLayout0001(dt);
    });

    run('MultimediaGalleryAlbumsLayout0002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsLayout0002(dt);
    });

    run('MultimediaGalleryAlbumsLayout0003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsLayout0003(dt);
    });

    run('MultimediaGalleryAlbumsLayout0004', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsLayout0004(dt);
    });

    run('MultimediaGalleryAlbumsLayout0005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsLayout0005(dt);
    });

    run('MultimediaGalleryAlbumsOther0001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0001(dt);
    });

    run('MultimediaGalleryAlbumsOther0002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0002(dt);
    });

    run('MultimediaGalleryAlbumsOther0003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0003(dt);
    });

    run('MultimediaGalleryAlbumsOther0004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0004(dt);
    });

    run('MultimediaGalleryAlbumsUpgrade0001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsUpgrade0001(dt);
    });

    run('MultimediaGalleryAlbumsUpgrade0002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsUpgrade0002(dt);
    });

    run('MultimediaGallery50WPerfermance012', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGallery50WPerfermance012(dt);
    });

    run('MultimediaGallery50WPerfermance013', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGallery50WPerfermance013(dt);
    });

    run('MultimediaGallery50WPerfermance014', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGallery50WPerfermance014(dt);
    });

    run('MultimediaGallery50WPerfermance015', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGallery50WPerfermance015(dt);
    });

    run('MultimediaGallery50WPerfermance030', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGallery50WPerfermance030(dt);
    });

    run('MultimediaGallery50WPerfermance031', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGallery50WPerfermance031(dt);
    });

    run('MultimediaGallery50WPerfermance032', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGallery50WPerfermance032(dt);
    });

    run('MultimediaGallery50WPerfermance033', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGallery50WPerfermance033(dt);
    });
    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0035', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0035(dt);
    });

    run('MultimediaGalleryAlbumsOther0036', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0036(dt);
    });

    run('MultimediaGalleryAlbumsOther0037', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0037(dt);
    });

    run('MultimediaGalleryAlbumsOther0038', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0038(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    run('MultimediaGalleryAlbumsOther0034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      await multimediaGalleryAlbumsOther0034(dt);
    });

    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachIMediaAPPGalleryVideodeletion001').init();
      dt.log.i('afterEach IMediaAPPGalleryVideodeletion001 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach IMediaAPPGalleryVideodeletion001 finish');
    });

    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllIMediaAPPGalleryVideodeletion001').init();
      dt.log.i('afterAll IMediaAPPGalleryVideodeletion001 start');
      await Exit.browser();
      dt.log.i('afterAll IMediaAPPGalleryVideodeletion001 finish');
    });
  });
}