import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Float "mo:base/Float";

actor {
  type Donation = {
    id: Nat;
    cause: Text;
    amount: Float;
    date: Time.Time;
    description: Text;
    donor: Text;
  };

  var donations = Buffer.Buffer<Donation>(0);

  public func addDonation(cause: Text, amount: Float, description: Text, donor: Text) : async Nat {
    let id = donations.size();
    let newDonation: Donation = {
      id;
      cause;
      amount;
      date = Time.now();
      description;
      donor;
    };
    donations.add(newDonation);
    id
  };

  public query func getTotalForCause(cause: Text) : async Float {
    var total: Float = 0;
    for (donation in donations.vals()) {
      if (donation.cause == cause) {
        total += donation.amount;
      };
    };
    total
  };

  public query func getDonationsByDonor(donor: Text) : async [Donation] {
    let donorDonations = Buffer.Buffer<Donation>(0);
    for (donation in donations.vals()) {
      if (donation.donor == donor) {
        donorDonations.add(donation);
      };
    };
    Buffer.toArray(donorDonations)
  };

  public query func getDonationStatistics() : async {
    totalDonations: Float;
    numberOfDonors: Nat;
    averageDonation: Float;
  } {
    var total: Float = 0;
    var donors = Buffer.Buffer<Text>(0);
    
    for (donation in donations.vals()) {
      total += donation.amount;
      var isDonorFound = false;
      for (existingDonor in donors.vals()) {
        if (existingDonor == donation.donor) {
          isDonorFound := true;
        };
      };
      if (not isDonorFound) {
        donors.add(donation.donor);
      };
    };

    {
      totalDonations = total;
      numberOfDonors = donors.size();
      averageDonation = if (donations.size() > 0) total / Float.fromInt(donations.size()) else 0;
    }
  };
}