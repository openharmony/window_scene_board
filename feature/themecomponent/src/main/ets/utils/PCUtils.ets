import { osAccount, systemParameterEnhance } from "@kit.BasicServicesKit";
import { LogUtil } from "@ohos/lottie";

export class PCUtils {
  /**
   * Check if disable modify wallpaper
   *
   * @returns if disable, return true
   */
  public static async isModifyWallpaperDisable(): Promise<boolean> {
    try {
      const isEnterpriseDevice: boolean =
        systemParameterEnhance.getSync('const.edm.is_enterprise_device', 'false') === 'true';
      if (!isEnterpriseDevice) {
        LogUtil.info('not enterprise device');
        return false;
      }
      const result: boolean =
        await osAccount.getAccountManager().isOsAccountConstraintEnabled('constraint.wallpaper.set');
      LogUtil.info(`set wallpaper isOsAccountConstraintEnabled : ${result}`);
      return result;
    } catch (e) {
      LogUtil.info(`get isModifyWallpaperDisable error, code:${e?.code} message:${e?.message}`);
      return false;
    }
  }
}