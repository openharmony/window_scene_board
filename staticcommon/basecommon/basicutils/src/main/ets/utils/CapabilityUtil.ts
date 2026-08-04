export class CapabilityUtil {
  /**
   * 判断状态栏管理能力是否可用
   */
  static isStatusBarAvailable(): boolean {
    return canIUse("SystemCapability.PCService.StatusBarManager");
  }

}