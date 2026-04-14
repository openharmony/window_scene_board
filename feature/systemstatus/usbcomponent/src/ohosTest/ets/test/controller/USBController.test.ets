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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import USBController from '../../../../main/ets/controller/USBController'
import volumeManager from '@ohos.file.volumeManager'

export function USBControllerTest() {

  describe('LocationControllerStyleConfigurationTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_addUSBDeviceByVolumeList',0,()=>{
      USBController.addUSBDeviceByVolumeList([]);
      volumeManager.mount('test01');
      volumeManager.getAllVolumes().then((date=>{
          USBController.addUSBDeviceByVolumeList(date);
          USBController.addUSBDeviceByVolumeList(date);
      }))
      expect(USBController.getState())
    })

    it('test_deleteUSBByVolumeId', 0, () => {
      USBController.deleteUSBByVolumeId('test01');
    })
    it('test_isClose', 0, () => {
      USBController.isClose();
      expect(USBController.getUSBList().length === 0 ).assertTrue()
    })
  })
}